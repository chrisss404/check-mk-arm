#!/bin/bash

VERSION="1.6.0p19"
DEB_FULLNAME="check_mk_server for Ubuntu 20.04 on RPI4"
DEB_EMAIL="your@email.foo"

# for aarch64
NETSNMP=net-snmp-0b32548
NSCA=nsca-2.9.1
NAGIOS=nagios-3.5.1
STUNNEL=stunnel-5.50
PNP4NAGIOS=pnp4nagios-0.6.26
SNAP7=snap7-full-1.4.2

### NOTHING TO CHANGE AFTER HERE

if [ $# -gt 0 ]; then
  VERSION="$1"
fi

BASEDIR=$(pwd)
HWPLATFORM=$(uname -i)

echo "-----> BUILDING CHECK_MK ${VERSION} <-----"

# install build dependencies
echo "-----> INSTALLING BUILD DEPENDENCIES <-----"
apt-get update
apt-get -y install apache2 build-essential debhelper dnsutils dpatch flex fping git \
           git-buildpackage make rpcbind rrdtool smbclient snmp apache2-dev \
	   default-libmysqlclient-dev dietlibc-dev libboost-all-dev libboost-dev \
           libdbi-dev libevent-dev libffi-dev libfreeradius-dev libgd-dev \
	   libglib2.0-dev libgnutls28-dev libgsf-1-dev libkrb5-dev libmcrypt-dev \
           libncurses-dev libpango1.0-dev libpcap-dev libperl-dev libpq-dev \
           libreadline-dev librrd-dev libsqlite3-dev libssl-dev libxml2-dev tk-dev uuid-dev

# downloading check_mk sources
if [ ! -f check-mk-raw-${VERSION}.cre.tar.gz ]; then
  echo "-----> DOWNLOADING CHECK_MK SOURCES <-----"
  wget https://mathias-kettner.de/support/${VERSION}/check-mk-raw-${VERSION}.cre.tar.gz 
fi

# unpacking check_mk sources
echo "-----> UNPACKING CHECK_MK SOURCES <-----"
if [ -d check-mk-raw-${VERSION}.cre ]; then
  rm -r check-mk-raw-${VERSION}.cre
fi
tar -xzf check-mk-raw-${VERSION}.cre.tar.gz

# modifications for aarch64
if [ $HWPLATFORM = aarch64 ]; then
  update_cfg_guess()
  {
    cp /usr/share/automake-1.16/config.guess .
    cd ..
  }

  echo "-----> UPDATE CONFIG.GUESS FOR AARCH64 <-----"
  cd $BASEDIR/check-mk-raw-${VERSION}.cre/omd/packages/net-snmp
  tar -xzf $NETSNMP.tar.gz
  cd $NETSNMP; update_cfg_guess
  rm $NETSNMP.tar.gz
  tar -czf $NETSNMP.tar.gz $NETSNMP && rm -r $NETSNMP

  cd ../nsca
  tar -xzf $NSCA.tar.gz
  cd $NSCA; update_cfg_guess
  rm $NSCA.tar.gz
  tar -czf $NSCA.tar.gz $NSCA && rm -r $NSCA

  cd ../nagios
  tar -xzf $NAGIOS.tar.gz
  cd $NAGIOS; update_cfg_guess
  cd $NAGIOS/tap; update_cfg_guess; cd ..
  rm $NAGIOS.tar.gz
  tar -czf $NAGIOS.tar.gz $NAGIOS && rm -r $NAGIOS

  cd ../stunnel
  tar -xzf $STUNNEL.tar.gz
  cd $STUNNEL; update_cfg_guess
  rm $STUNNEL.tar.gz
  tar -czf $STUNNEL.tar.gz $STUNNEL && rm -r $STUNNEL

  cd ../pnp4nagios
  tar -xzf $PNP4NAGIOS.tar.gz
  cd $PNP4NAGIOS; update_cfg_guess
  rm $PNP4NAGIOS.tar.gz
  tar -czf $PNP4NAGIOS.tar.gz $PNP4NAGIOS && rm -r $PNP4NAGIOS

  echo "-----> CREATE MISSING aarch64_linux.mk <-----"
  cd ../snap7
  tar -xzf $SNAP7.tar.gz
  cp $SNAP7/build/unix/arm_v6_linux.mk $SNAP7/build/unix/aarch64_linux.mk
  sed -i 's/arm_v6/aarch64/' $SNAP7/build/unix/aarch64_linux.mk
  rm $SNAP7.tar.gz
  tar -czf $SNAP7.tar.gz $SNAP7 && rm -r $SNAP7

  echo "-----> REMOVE NAVICLI BUILD <-----"
  sed -i '/.*navicli/d' $BASEDIR/check-mk-raw-${VERSION}.cre/omd/Makefile
fi

# build package
echo "-----> BUILDING PACKAGE <-----"
cd $BASEDIR/check-mk-raw-${VERSION}.cre
make -C omd setup
DEBFULLNAME="$DEB_FULLNAME" DEBEMAIL="$DEB_EMAIL" make deb

# cleanup
if [ $? -eq 0 ]; then
  mv check-mk-raw-${VERSION}*.deb ..
  cd ..
  rm -rf check-mk-raw-${VERSION}.cre
fi



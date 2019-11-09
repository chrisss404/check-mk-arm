#!/bin/bash

VERSION="1.6.0p2"
SNAP7_VERSION="1.4.2"
FAST_BUILD=0

if [ $# -gt 0 ]; then
  VERSION="$1"
fi

echo "building Check_MK ${VERSION}..."

# get check_mk sources and build dependencies
apt-get -y install apache2 build-essential debhelper dnsutils dpatch flex fping git git-buildpackage make rpcbind \
    rrdtool smbclient snmp apache2-dev default-libmysqlclient-dev dietlibc-dev libboost-all-dev libboost-dev \
    libcloog-ppl1 libdbi-dev libevent-dev libffi-dev libfreeradius-dev libgd-dev libglib2.0-dev \
    libgnutls28-dev libgsf-1-dev libkrb5-dev libmcrypt-dev libncurses-dev libpango1.0-dev libpcap-dev libperl-dev \
    libpq-dev libreadline-dev librrd-dev libsqlite3-dev libssl-dev libxml2-dev tk-dev uuid-dev

wget -qO- https://mathias-kettner.de/support/${VERSION}/check-mk-raw-${VERSION}.cre.tar.gz | tar -xvz
cd check-mk-raw-${VERSION}.cre
./configure --with-boost-libdir=/usr/lib/arm-linux-gnueabihf

# patch files
patch -p0 < ../checks-livestatus-status-add-empty-string-check.patch
patch -p0 < ../omd-Makefile-remove-module-navicli.patch
patch -p0 < ../omdlib-reduce-certificate-maximum-validity-period.patch
if [ ${FAST_BUILD} -eq 1 ]; then
    patch -p0 < ../python-Makefile-disable-optimization.patch
fi

# prepare snap7
tar -xvzf omd/packages/snap7/snap7-full-${SNAP7_VERSION}.tar.gz -C omd/packages/snap7
cp omd/packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/arm_v6_linux.mk omd/packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/armv6l_linux.mk
ln -s arm_v6-linux omd/packages/snap7/snap7-full-${SNAP7_VERSION}/build/bin/armv6l-linux
cp omd/packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/arm_v7_linux.mk omd/packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/armv7l_linux.mk
ln -s arm_v7-linux omd/packages/snap7/snap7-full-${SNAP7_VERSION}/build/bin/armv7l-linux
tar czf omd/packages/snap7/snap7-full-${SNAP7_VERSION}.tar.gz -C omd/packages/snap7 snap7-full-${SNAP7_VERSION}

# compile and package
make deb DEBFULLNAME="Christian Hofer" DEBEMAIL=chrisss404@gmail.com

# cleanup
if [ $? -eq 0 ]; then
    mv check-mk-raw-${VERSION}* ..
    cd ..
    rm -rf check-mk-raw-${VERSION}.cre
fi

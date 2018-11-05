#!/bin/bash

VERSION="1.5.0p2"
SNAP7_VERSION="1.3.0"
FAST_BUILD=0

if [ $# -gt 0 ]; then
  VERSION="$1"
fi

echo "building Check_MK ${VERSION}..."

# Check for recommended compiler
if ! gcc --version | grep -q 7.3.0; then
    echo ""
    echo "================================================================================"
    echo "=              Could not find recommended compiler version 7.3.0.              ="
    echo "=                                                                              ="
    echo "=                  Run \`bash build_gcc.sh 7.3.0\` to build it.                  ="
    echo "=                                                                              ="
    echo "=  If you wish to proceed with your current compiler, just wait for a minute.  ="
    echo "================================================================================"
    echo ""
    sleep 1m
fi

# get check_mk sources and build dependencies
apt-get -y install apache2 build-essential debhelper dnsutils dpatch flex fping git git-buildpackage make rpcbind \
    rrdtool smbclient snmp apache2-dev default-libmysqlclient-dev dietlibc-dev libboost-all-dev libboost-dev \
    libcloog-ppl1 libcurl4-openssl-dev libdbi-dev libevent-dev libffi-dev libfreeradius-dev libgd-dev libglib2.0-dev \
    libgnutls28-dev libgsf-1-dev libkrb5-dev libmcrypt-dev libncurses5-dev libpango1.0-dev libpcap-dev libperl-dev \
    libpq-dev libreadline-dev librrd-dev libsqlite3-dev libssl1.0-dev libxml2-dev tk-dev uuid-dev

wget -qO- https://mathias-kettner.de/support/${VERSION}/check-mk-raw-${VERSION}.cre.tar.gz | tar -xvz
cd check-mk-raw-${VERSION}.cre
./configure --with-boost-libdir=/usr/lib/arm-linux-gnueabihf

# patch files
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

#!/bin/bash

VERSION="1.5.0p2"
SNAP7_VERSION="1.3.0"
FAST_BUILD=0

if [ $# -gt 0 ]; then
  VERSION="$1"
fi

echo "building Check_MK ${VERSION}..."

# Get compiler with support for C++17 language features
if [ ! -d "/opt/gcc-8.1.0" ] ; then
    wget -qO- https://bitbucket.org/sol_prog/raspberry-pi-gcc-binary/raw/bad4e5d14042cdad8f081119e5808fa3798217f6/gcc-8.1.0.tar.bz2?at=master | tar jx
    mv gcc-8.1.0 /opt
    update-alternatives --install /usr/bin/gcc gcc /opt/gcc-8.1.0/bin/gcc-8.1.0 10
    update-alternatives --install /usr/bin/g++ g++ /opt/gcc-8.1.0/bin/g++-8.1.0 10
fi
update-alternatives --set gcc /opt/gcc-8.1.0/bin/gcc-8.1.0
update-alternatives --set g++ /opt/gcc-8.1.0/bin/g++-8.1.0

# get check_mk sources and build dependencies
apt-get -y install git make debhelper flex build-essential libssl1.0-dev libboost-dev libboost-all-dev libncurses5-dev libgd-dev libglib2.0-dev libgnutls28-dev default-libmysqlclient-dev libpango1.0-dev libperl-dev libxml2-dev libsqlite3-dev uuid-dev apache2-dev libpcap-dev libgsf-1-dev libkrb5-dev tk-dev
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

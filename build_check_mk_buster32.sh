#!/bin/bash

VERSION="2.0.0p1"
SNAP7_VERSION="1.4.2"

if [ $# -gt 0 ]; then
  VERSION="$1"
fi

echo "building Check_MK ${VERSION}..."

# get check_mk sources and build dependencies
if [ ${INSTALL_DEPENDENCIES:-0} -eq 1 ]; then
    apt-get -y install apache2 build-essential cmake debhelper dnsutils dpatch flex fping git git-buildpackage make \
        rpcbind rrdtool smbclient snmp apache2-dev default-libmysqlclient-dev dietlibc-dev libboost-all-dev \
        libboost-dev libcurl4-openssl-dev libcloog-ppl1 libdbi-dev libevent-dev libffi-dev libfreeradius-dev libgd-dev \
        libglib2.0-dev libgnutls28-dev libgsf-1-dev libkrb5-dev libmcrypt-dev libncurses-dev libpango1.0-dev \
        libpcap-dev libperl-dev libpq-dev libreadline-dev librrd-dev libsqlite3-dev libssl-dev libxml2-dev \
        libxmlsec1-dev tk-dev uuid-dev
fi

wget -qO- https://download.checkmk.com/checkmk/${VERSION}/check-mk-raw-${VERSION}.cre.tar.gz | tar -xvz
cd check-mk-raw-${VERSION}.cre
./configure

# patch files
patch -p0 < ../omd-Makefile-remove-module-navicli.patch
patch -p0 < ../omdlib-reduce-certificate-maximum-validity-period.patch
patch -p0 < ../python-make-add-fno-semantic-interposition.patch
patch -p0 < ../python-make-set-arm-architecture.patch

# prepare lasso
tar -xvzf omd/packages/lasso/lasso-2.6.1.2.tar.gz -C omd/packages/lasso
patch -p0 < ../lasso-docs-make-fix-error.patch
tar czf omd/packages/lasso/lasso-2.6.1.2.tar.gz -C omd/packages/lasso lasso-2.6.1.2

# prepare snap7
tar -xvzf omd/packages/snap7/snap7-${SNAP7_VERSION}.tar.gz -C omd/packages/snap7
cp omd/packages/snap7/snap7-${SNAP7_VERSION}/build/unix/arm_v6_linux.mk omd/packages/snap7/snap7-${SNAP7_VERSION}/build/unix/armv6l_linux.mk
ln -s arm_v6-linux omd/packages/snap7/snap7-${SNAP7_VERSION}/build/bin/armv6l-linux
cp omd/packages/snap7/snap7-${SNAP7_VERSION}/build/unix/arm_v7_linux.mk omd/packages/snap7/snap7-${SNAP7_VERSION}/build/unix/armv7l_linux.mk
ln -s arm_v7-linux omd/packages/snap7/snap7-${SNAP7_VERSION}/build/bin/armv7l-linux
tar czf omd/packages/snap7/snap7-${SNAP7_VERSION}.tar.gz -C omd/packages/snap7 snap7-${SNAP7_VERSION}

# compile and package
make deb DEBFULLNAME="Christian Hofer" DEBEMAIL=chrisss404@gmail.com

# cleanup
if [ $? -eq 0 ]; then
    mv check-mk-raw-${VERSION}* ..
    cd ..
    rm -rf check-mk-raw-${VERSION}.cre
fi

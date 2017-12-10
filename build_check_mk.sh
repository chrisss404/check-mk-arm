#!/bin/bash

VERSION="1.4.0p19"
SNAP7_VERSION="1.3.0"

if [ $# -gt 0 ]; then
  VERSION="$1"
fi

echo "building Check_MK ${VERSION}..."

# get packages
apt-get -y install git make
wget -qO- https://mathias-kettner.de/support/${VERSION}/check-mk-raw-${VERSION}.cre.tar.gz | tar -xvz
cd check-mk-raw-${VERSION}.cre
./configure

# patch files
patch -p0 < ../BuildHelper.patch
patch -p0 < ../Makefile.patch
cp ../libssl_compat.h packages/nrpe/libssl_compat.h
patch -p0 < ../nrpe-Makefile.patch

# prepare snap7
tar -xvzf packages/snap7/snap7-full-${SNAP7_VERSION}.tar.gz -C packages/snap7
cp packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/arm_v6_linux.mk packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/armv6l_linux.mk
ln -s arm_v6-linux packages/snap7/snap7-full-${SNAP7_VERSION}/build/bin/armv6l-linux
tar czf packages/snap7/snap7-full-${SNAP7_VERSION}.tar.gz -C packages/snap7 snap7-full-${SNAP7_VERSION}

# compile and package
make deb EDITION=raw DEBFULLNAME=Christian Hofer DEBEMAIL=chrisss404@gmail.com

# cleanup
cd ..
rm -rf check-mk-raw-${VERSION}.cre

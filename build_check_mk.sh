#!/bin/bash

VERSION="1.4.0p34"
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

# prepare mk-livestatus (replace usage of std::atomic_uint32_t)
tar -xvzf packages/mk-livestatus/mk-livestatus-${VERSION}.tar.gz -C packages/mk-livestatus
find packages/mk-livestatus/mk-livestatus-${VERSION}/src -type f -exec sed -i 's/std::atomic_int32_t/std::atomic<std::int32_t>/' "{}" +;
tar czf packages/mk-livestatus/mk-livestatus-${VERSION}.tar.gz -C packages/mk-livestatus mk-livestatus-${VERSION}

# prepare snap7
tar -xvzf packages/snap7/snap7-full-${SNAP7_VERSION}.tar.gz -C packages/snap7
cp packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/arm_v6_linux.mk packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/armv6l_linux.mk
ln -s arm_v6-linux packages/snap7/snap7-full-${SNAP7_VERSION}/build/bin/armv6l-linux
cp packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/arm_v7_linux.mk packages/snap7/snap7-full-${SNAP7_VERSION}/build/unix/armv7l_linux.mk
ln -s arm_v7-linux packages/snap7/snap7-full-${SNAP7_VERSION}/build/bin/armv7l-linux
tar czf packages/snap7/snap7-full-${SNAP7_VERSION}.tar.gz -C packages/snap7 snap7-full-${SNAP7_VERSION}

# compile and package
make deb EDITION=raw DEBFULLNAME="Christian Hofer" DEBEMAIL=chrisss404@gmail.com

# cleanup
if [ $? -eq 0 ]; then
    cd ..
    rm -rf check-mk-raw-${VERSION}.cre
fi

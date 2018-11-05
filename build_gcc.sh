#!/bin/bash

VERSION="7.3.0"

if [ $# -gt 0 ]; then
  VERSION="$1"
fi

echo "building gcc-${VERSION}..."

# get gcc sources and build dependencies
apt-get -y install build-essential make
wget -qO- https://mirror.kumi.systems/gnu/gcc/gcc-${VERSION}/gcc-${VERSION}.tar.gz | tar -xvz

cd gcc-${VERSION}
contrib/download_prerequisites

# compile and install
mkdir ../build-gcc-${VERSION}
cd ../build-gcc-${VERSION}
../gcc-${VERSION}/configure -v --enable-languages=c,c++ --prefix=/opt/gcc-${VERSION} --program-suffix=-${VERSION} \
    --with-arch=armv6 --with-fpu=vfp --with-float=hard --build=arm-linux-gnueabihf --host=arm-linux-gnueabihf \
    --target=arm-linux-gnueabihf
make
make install-strip

# set as default compiler
update-alternatives --install /usr/bin/gcc gcc /opt/gcc-${VERSION}/bin/gcc-${VERSION} 10
update-alternatives --install /usr/bin/g++ g++ /opt/gcc-${VERSION}/bin/g++-${VERSION} 10

update-alternatives --set gcc /opt/gcc-${VERSION}/bin/gcc-${VERSION}
update-alternatives --set g++ /opt/gcc-${VERSION}/bin/g++-${VERSION}

# cleanup
cd ..
rm -rf build-gcc-${VERSION}
rm -rf gcc-${VERSION}

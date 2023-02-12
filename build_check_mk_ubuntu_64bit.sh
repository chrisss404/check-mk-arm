#!/bin/bash

CHECKMK_VERSION="2.1.0p21"
NAGIOS_VERSION="3.5.1"
NSCA_VERSION="2.9.1"
PNP4NAGIOS_VERSION="0.6.26"
SNAP7_VERSION="1.4.2"

if [ $# -gt 0 ]; then
  CHECKMK_VERSION="$1"
fi

echo "building Check_MK ${CHECKMK_VERSION}..."

# get check_mk build dependencies
if [ ${INSTALL_DEPENDENCIES:-0} -eq 1 ]; then
    sudo apt-get -y install apache2-dev build-essential cmake devscripts flex freetds-dev libcurl4-openssl-dev \
        libffi-dev libglib2.0-dev libgsf-1-dev libjpeg-dev libkrb5-dev libldap2-dev libncurses5-dev libpango1.0-dev \
        libpcap-dev libperl-dev libpq-dev libreadline-dev librrd-dev libsasl2-dev libsodium-dev libssl-dev libxml2-dev \
        libxmlsec1-dev libxmlsec1-openssl libxslt-dev patchelf pipenv python3.9 python3.9-distutils python3.9-dev \
        rsync zlib1g-dev
fi

# get check_mk sources
if [ ! -f check-mk-raw-${CHECKMK_VERSION}.cre.tar.gz ]; then
    wget -q https://download.checkmk.com/checkmk/${CHECKMK_VERSION}/check-mk-raw-${CHECKMK_VERSION}.cre.tar.gz
fi
rm -rf check-mk-raw-${CHECKMK_VERSION}.cre
tar xfz check-mk-raw-${CHECKMK_VERSION}.cre.tar.gz

# configure check_mk
cd check-mk-raw-${CHECKMK_VERSION}.cre
./configure

# apply patches
patch -p0 < ../omd-Makefile-remove-module-navicli.patch
patch -p0 < ../python-make-add-fno-semantic-interposition.patch
patch -p0 < ../python-make-set-aarch64-architecture.patch
patch -p0 < ../protobuf-make-add-latomic.patch
patch -p0 < ../pipfile-remove-pbr.patch
patch -p0 < ../pipfile-remove-playwright.patch

# prepare nagios
tar xvzf omd/packages/nagios/nagios-${NAGIOS_VERSION}.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/nagios-${NAGIOS_VERSION}/
tar czf omd/packages/nagios/nagios-${NAGIOS_VERSION}.tar.gz -C /tmp nagios-${NAGIOS_VERSION}
rm -rf /tmp/nagios-${NAGIOS_VERSION}

# prepare nsca
tar xzf omd/packages/nsca/nsca-${NSCA_VERSION}.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/nsca-${NSCA_VERSION}/
tar czf omd/packages/nsca/nsca-${NSCA_VERSION}.tar.gz -C /tmp nsca-${NSCA_VERSION}
rm -rf /tmp/nsca-${NSCA_VERSION}

# prepare pnp4nagios
tar xzf omd/packages/pnp4nagios/pnp4nagios-${PNP4NAGIOS_VERSION}.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/pnp4nagios-${PNP4NAGIOS_VERSION}/
tar czf omd/packages/pnp4nagios/pnp4nagios-${PNP4NAGIOS_VERSION}.tar.gz -C /tmp pnp4nagios-${PNP4NAGIOS_VERSION}
rm -rf /tmp/pnp4nagios-${PNP4NAGIOS_VERSION}

# prepare snap7
tar xvzf omd/packages/snap7/snap7-${SNAP7_VERSION}.tar.gz -C /tmp
cp /tmp/snap7-${SNAP7_VERSION}/build/unix/arm_v6_linux.mk /tmp/snap7-${SNAP7_VERSION}/build/unix/aarch64_linux.mk
sed -i  's/arm_v6/aarch64/' /tmp/snap7-${SNAP7_VERSION}/build/unix/aarch64_linux.mk
tar czf omd/packages/snap7/snap7-${SNAP7_VERSION}.tar.gz -C /tmp snap7-${SNAP7_VERSION}
rm -rf /tmp/snap7-${SNAP7_VERSION}

# setup pipenv
sudo bash buildscripts/infrastructure/build-nodes/scripts/install-pipenv.sh

# compile and package
make deb DEBFULLNAME="Martin Petersen" DEBEMAIL=martin@petersen20.de

# cleanup
if [ $? -eq 0 ]; then
    mv check-mk-raw-${CHECKMK_VERSION}* ..
    cd ..
    rm -rf check-mk-raw-${CHECKMK_VERSION}.cre
fi

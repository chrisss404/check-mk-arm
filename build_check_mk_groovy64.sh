#!/bin/bash

VERSION="2.1.0p2"
SNAP7_VERSION="1.4.2"

if [ $# -gt 0 ]; then
  VERSION="$1"
fi

echo "building Check_MK ${VERSION}..."

if [ ! -d check-mk-raw-${VERSION}.cre ]; then
   if [ ! -f check-mk-raw-${VERSION}.cre.tar.gz ]; then
      wget -q https://download.checkmk.com/checkmk/${VERSION}/check-mk-raw-${VERSION}.cre.tar.gz
   fi
   tar xfz check-mk-raw-${VERSION}.cre.tar.gz
fi

cd check-mk-raw-${VERSION}.cre
./configure

# patch files
patch -p0 < ../omd-Makefile-remove-module-navicli.patch
patch -p0 < ../omdlib-reduce-certificate-maximum-validity-period.patch
patch -p0 < ../python-make-add-fno-semantic-interposition.patch
patch -p0 < ../python-make-set-aarch64-architecture.patch
patch -p0 < ../protobuf-make-add-latomic.patch
patch -p0 < ../pipfile-remove-pbr.patch
patch -p0 < ../pipfile-remove-playwright.patch

touch agents/windows/check_mk.user.yml
touch agents/windows/check_mk_agent_arm64.{exe,msi}

tar xzf omd/packages/net-snmp/net-snmp-0b32548.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/net-snmp-0b32548/
tar czf omd/packages/net-snmp/net-snmp-0b32548.tar.gz -C /tmp net-snmp-0b32548
rm -rf /tmp/net-snmp-0b32548

tar xzf omd/packages/nagios/nagios-3.5.1.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/nagios-3.5.1/
tar czf omd/packages/nagios/nagios-3.5.1.tar.gz -C /tmp nagios-3.5.1
rm -rf /tmp/nagios-3.5.1

tar xzf omd/packages/nsca/nsca-2.9.1.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/nsca-2.9.1/
tar czf omd/packages/nsca/nsca-2.9.1.tar.gz -C /tmp nsca-2.9.1
rm -rf /tmp/nsca-2.9.1

tar xzf omd/packages/pnp4nagios/pnp4nagios-0.6.26.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/pnp4nagios-0.6.26/
tar czf omd/packages/pnp4nagios/pnp4nagios-0.6.26.tar.gz -C /tmp pnp4nagios-0.6.26
rm -rf /tmp/pnp4nagios-0.6.26

tar xzf omd/packages/stunnel/stunnel-5.50.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/stunnel-5.50/
tar czf omd/packages/stunnel/stunnel-5.50.tar.gz -C /tmp stunnel-5.50
rm -rf /tmp/stunnel-5.50

# prepare snap7
tar -xvzf omd/packages/snap7/snap7-${SNAP7_VERSION}.tar.gz -C /tmp
cp /tmp/snap7-${SNAP7_VERSION}/build/unix/arm_v6_linux.mk /tmp/snap7-${SNAP7_VERSION}/build/unix/aarch64_linux.mk
sed -i  's/arm_v6/aarch64/' /tmp/snap7-${SNAP7_VERSION}/build/unix/aarch64_linux.mk
tar czf omd/packages/snap7/snap7-${SNAP7_VERSION}.tar.gz -C /tmp snap7-${SNAP7_VERSION}
rm -rf /tmp/snap7-${SNAP7_VERSION}

# setup pipenv
bash buildscripts/infrastructure/build-nodes/scripts/install-pipenv.sh

# compile and package
make deb DEBFULLNAME="Martin Petersen" DEBEMAIL=martin@petersen20.de

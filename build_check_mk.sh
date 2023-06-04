#!/bin/bash

VERSION="2.2.0p1"

if [ $# -gt 0 ]; then
  VERSION="$1"
fi

start_time=$(date +%s)

echo "`date +%Y-%m-%d_%H-%M-%S` building Check_MK ${VERSION}..."

if [ ! -d check-mk-raw-${VERSION}.cre ]; then
   echo "checking if check-mk source exists ..."
   if [ ! -f check-mk-raw-${VERSION}.cre.tar.gz ]; then
      echo "getting check-mk source ..."
      wget -q https://download.checkmk.com/checkmk/${VERSION}/check-mk-raw-${VERSION}.cre.tar.gz
   fi
   echo "untar check-mk source ..."
   tar xfz check-mk-raw-${VERSION}.cre.tar.gz
fi


echo "going to check-mk source path ...."
cd check-mk-raw-${VERSION}.cre

export USE_EXTERNAL_PIPENV_MIRROR=true

# patch files
echo "installing patchs ...."
patch -p0 < ../omd-Makefile.patch
patch -p0 < ../python-make-add-fno-semantic-interposition.patch
patch -p0 < ../python-make-set-aarch64-architecture.patch
patch -p0 < ../protobuf-make-add-latomic.patch
patch -p0 < ../pipfile-remove-entries.patch
patch -p0 < ../bazel-set-aarch64-architecture.patch
patch -p0 < ../modify-heirloom-src-url.patch
patch -p0 < ../modify-path-fake-windows.patch

./configure

scripts/fake-windows-artifacts

echo "updating nagios archive for supporting aarch64 ..."
tar xzf omd/packages/nagios/nagios-3.5.1.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/nagios-3.5.1/
tar czf omd/packages/nagios/nagios-3.5.1.tar.gz -C /tmp nagios-3.5.1
rm -rf /tmp/nagios-3.5.1

echo "updating pnp4nagios archive for supporting aarch64 ..."
tar xzf omd/packages/pnp4nagios/pnp4nagios-0.6.26.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/pnp4nagios-0.6.26/
tar czf omd/packages/pnp4nagios/pnp4nagios-0.6.26.tar.gz -C /tmp pnp4nagios-0.6.26
rm -rf /tmp/pnp4nagios-0.6.26

echo "updating stunnel archive for supporting aarch64 ..."
tar xzf omd/packages/stunnel/stunnel-5.63.tar.gz -C /tmp
cp /usr/share/misc/config.guess /tmp/stunnel-5.63/
tar czf omd/packages/stunnel/stunnel-5.63.tar.gz -C /tmp stunnel-5.63
rm -rf /tmp/stunnel-5.63

echo "updating snap7 archive for supporting aarch64 ..."
tar xzf omd/packages/snap7/snap7-1.4.2.tar.gz -C /tmp
cp /tmp/snap7-1.4.2/build/unix/arm_v6_linux.mk /tmp/snap7-1.4.2/build/unix/aarch64_linux.mk
sed -i  's/arm_v6/aarch64/' /tmp/snap7-1.4.2/build/unix/aarch64_linux.mk
tar czf omd/packages/snap7/snap7-1.4.2.tar.gz -C /tmp snap7-1.4.2
rm -rf /tmp/snap7-1.4.2

# setup pipenv
bash buildscripts/infrastructure/build-nodes/scripts/install-pipenv.sh

echo "starting make deb ..."
# compile and package
make deb DEBFULLNAME="Martin Petersen" DEBEMAIL=martin@petersen20.de

if [ $? -eq 0 ]; then
    cp check-mk-raw-${VERSION}*.deb /opt/build-mk/debs/
    cd ..
    echo "`date +%Y-%m-%d_%H-%M-%S` SUCCESS :-)"
    end_time=$(date +%s)
    elapsed=$(( end_time - start_time ))
    eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
fi

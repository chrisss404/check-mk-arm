
## Checkmk for Raspberry Pi

The pre-built packages are tested on a Raspberry Pi 3 running [Raspberry Pi OS](https://www.raspberrypi.org/downloads/raspberry-pi-os/). Consider [building Checkmk yourself](#build-it-yourself) if you intend to run it on a different system.
The pre-built 64bit packages are tested on a Raspberry Pi 4.

The sources of Checkmk can be found here: https://github.com/tribe29/checkmk

### Install Checkmk to Raspberry Pi OS

#### Get and install latest pre-built package

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/1.6.0p22 | grep browser_download_url | cut -d '"' -f 4 | grep buster_armhf.deb)  
    dpkg -i check-mk-raw-*.buster_armhf.deb
    apt-get install -f

#### Latest pre-built packages

* Checkmk 1.6.0 for Raspberry Pi OS Buster: [1.6.0p22](https://github.com/chrisss404/check-mk-arm/releases/tag/1.6.0p22)
* Checkmk 1.5.0 for Raspberry Pi OS (32-bit) Buster: [1.5.0p22](https://github.com/chrisss404/check-mk-arm/releases/tag/1.5.0p22)
* Checkmk 1.5.0 for Raspberry Pi OS (32-bit) Stretch: [1.5.0p20](https://github.com/chrisss404/check-mk-arm/releases/tag/1.5.0p20)
* Checkmk 1.4.0 for Raspberry Pi OS (32-bit) Stretch: [1.4.0p35](https://github.com/chrisss404/check-mk-arm/releases/tag/1.4.0p35)

### Install Checkmk to Ubuntu

#### Get and install latest pre-built package

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/1.6.0p20 | grep browser_download_url | cut -d '"' -f 4 | grep bionic_arm64.deb) 
    dpkg -i check-mk-raw-*.bionic_arm64.deb
    apt-get install -f

#### Latest pre-built packages

* Checkmk 1.6.0 for Ubuntu 18.04 LTS (64-bit) Bionic Beaver: [1.6.0p20](https://github.com/chrisss404/check-mk-arm/releases/1.6.0p20)

![Checkmk](https://raw.github.com/chrisss404/check-mk-arm/1.6.0/data/check_mk.png)

### Build it yourself

    # build a specific version of Checkmk, e.g.: 1.6.0p22
    bash build_check_mk.sh <version>
    
    # install dependencies and build Checkmk
    INSTALL_DEPENDENCIES=1 bash build_check_mk.sh <version>

### Patches

#### Reduce maximum validity period of site certificates

    cp omd/packages/omd/omdlib/certs.py omd/packages/omd/omdlib/certs_v2.py
    vim omd/packages/omd/omdlib/certs_v2.py
    -CERT_NOT_AFTER = 999 * 365 * 24 * 60 * 60  # 999 years by default
    +CERT_NOT_AFTER = 65 * 365 * 24 * 60 * 60  # 65 years by default
    diff -u omd/packages/omd/omdlib/certs.py omd/packages/omd/omdlib/certs_v2.py > ../omdlib-reduce-certificate-maximum-validity-period.patch

#### Remove module navicli

    cp omd/Makefile omd/Makefile_v2
    vim omd/Makefile_v2
    -    navicli \
    diff -u omd/Makefile omd/Makefile_v2 > ../omd-Makefile-remove-module-navicli.patch

#### Enable no-semantic-interposition compiler flag for python build

    cp omd/packages/Python/Python.make omd/packages/Python/Python.make_v2
    vim omd/packages/Python/Python.make_v2
    +            CFLAGS="${CFLAGS} -fno-semantic-interposition" \
    -            LDFLAGS="-Wl,--rpath,$(OMD_ROOT)/lib"
    +            LDFLAGS="-Wl,--rpath,$(OMD_ROOT)/lib -fno-semantic-interposition"
    diff -u omd/packages/Python/Python.make omd/packages/Python/Python.make_v2 > ../python-make-add-fno-semantic-interposition.patch

#### Switch to aarch64 for python build

    cp omd/packages/Python3/Python3.make omd/packages/Python3/Python3.make_v2
    vi omd/packages/Python3/Python3.make_v2
    
    diff -u omd/packages/Python3/Python3.make omd/packages/Python3/Python3.make_v2 > python-change-arch.patch

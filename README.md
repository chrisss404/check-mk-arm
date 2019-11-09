
## Check_MK for RaspberryPi

The pre-built packages are tested on a Raspberry Pi 3 running [Raspbian](https://www.raspberrypi.org/downloads/raspbian/). Keep in mind that you may encounter issues using a different setup.

The sources of Check_MK can be found here: https://github.com/tribe29/checkmk

### Install Check_MK on Raspbian

#### Get and install latest pre-built package

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/latest | grep browser_download_url | cut -d '"' -f 4) 
    dpkg -i check-mk-raw-*_armhf.deb
    apt-get install -f

#### Latest pre-built packages

* Check_MK 1.6.0 for Debian 10 Buster: [latest](https://github.com/chrisss404/check-mk-arm/releases/latest)
* Check_MK 1.5.0 for Debian 10 Buster: [1.5.0p22](https://github.com/chrisss404/check-mk-arm/releases/tag/1.5.0p22)
* Check_MK 1.5.0 for Debian 9 Stretch: [1.5.0p20](https://github.com/chrisss404/check-mk-arm/releases/tag/1.5.0p20)
* Check_MK 1.4.0 for Debian 9 Stretch: [1.4.0p35](https://github.com/chrisss404/check-mk-arm/releases/tag/1.4.0p35)

![Check_MK](https://raw.github.com/chrisss404/check-mk-arm/master/data/check_mk.png)

### Build it yourself

    bash build_check_mk.sh 1.6.0p2

### Patches

#### Skip site certificate validity if cert valid until is empty

    cp checks/livestatus_status checks/livestatus_status_v2
    vim checks/livestatus_status_v2
    -    if cert_valid_until is not None:
    +    if cert_valid_until is not None and cert_valid_until != "":
    diff -u checks/livestatus_status checks/livestatus_status_v2 > ../checks-livestatus-status-add-empty-string-check.patch

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

#### Disable optimization for python build

    cp omd/packages/python/Makefile omd/packages/python/Makefile_v2
    vim omd/packages/python/Makefile_v2
    -            OPTI="--enable-optimizations" ; \
    +            OPTI="" ; \
    diff -u omd/packages/python/Makefile omd/packages/python/Makefile_v2 > ../python-Makefile-disable-optimization.patch


## Checkmk for Raspberry Pi

On the [release](https://github.com/chrisss404/check-mk-arm/releases) page you can find deb packages targeting the following systems:

* [Raspberry Pi OS](https://www.raspberrypi.org/downloads/raspberry-pi-os/) (formerly Raspbian) "Buster" (armhf) on a RPi 3 and 4
* [Ubuntu](https://ubuntu.com/download/raspberry-pi/) "Hirsute" (arm64) on a RPi 4
* [Ubuntu](https://ubuntu.com/download/raspberry-pi/) "Groovy" (arm64) on a RPi 4
* [Ubuntu](https://ubuntu.com/download/raspberry-pi/) "Focal" (arm64) on a RPi 4

##### The builds for Focal and Groovy are untested !

If your system is listed you can follow the instructions from section [Install Checkmk to your RPi](#install-checkmk-to-your-rpi), otherwise please refer to section [Build Checkmk from sources](#build-checkmk-from-sources) to compile a package for your system.

The sources of Checkmk can be found here: https://github.com/tribe29/checkmk

![Checkmk](https://raw.github.com/chrisss404/check-mk-arm/master/data/check_mk.png)

### Recommended Configurations

##### Reduce the number of apache processes

Go to `Setup` > `General` > `Global settings` > `Site Management` and reduce the number at `Apache process tuning` to 5.

### Install Checkmk to your RPi

The following sections show how to download and install the DEB packages available from this repo. After the installation you could follow the [official user guide](https://docs.checkmk.com/latest/en/) to set it up and start your monitoring journey.

##### Raspberry Pi OS Buster (armhf)

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.0.0p15 | grep browser_download_url | cut -d '"' -f 4 | grep buster_armhf.deb) 
    dpkg -i check-mk-raw-*.buster_armhf.deb
    apt-get install -f

##### Ubuntu Impish (arm64)

Coming soon ....

##### Ubuntu Hirsute (arm64)

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.0.0p15 | grep browser_download_url | cut -d '"' -f 4 | grep hirsute_arm64.deb) 
    dpkg -i check-mk-raw-*.hirsute_arm64.deb
    apt-get install -f
    
##### Ubuntu Groovy (arm64)

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.0.0p15 | grep browser_download_url | cut -d '"' -f 4 | grep groovy_arm64.deb) 
    dpkg -i check-mk-raw-*.groovy_arm64.deb
    apt-get install -f
    
    ### Version 2.0.0.p15 is the last version for groovy, because of EOL from groovy.

##### Ubuntu Focal (arm64)

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.0.0p15 | grep browser_download_url | cut -d '"' -f 4 | grep focal_arm64.deb) 
    dpkg -i check-mk-raw-*.focal_arm64.deb
    apt-get install -f

### Package overview

##### Raspberry Pi OS (armhf)

* Checkmk 2.0.0 for Raspberry Pi OS Buster: [2.0.0p15](https://github.com/chrisss404/check-mk-arm/releases/tag/2.0.0p15)
* Checkmk 1.6.0 for Raspberry Pi OS Buster: [1.6.0p22](https://github.com/chrisss404/check-mk-arm/releases/tag/1.6.0p22)
* Checkmk 1.5.0 for Raspberry Pi OS Buster: [1.5.0p22](https://github.com/chrisss404/check-mk-arm/releases/tag/1.5.0p22)
* Checkmk 1.5.0 for Raspberry Pi OS Stretch: [1.5.0p20](https://github.com/chrisss404/check-mk-arm/releases/tag/1.5.0p20)
* Checkmk 1.4.0 for Raspberry Pi OS Stretch: [1.4.0p35](https://github.com/chrisss404/check-mk-arm/releases/tag/1.4.0p35)

##### Ubuntu (arm64)

* Checkmk 2.0.0 for Ubuntu 21.04 Hirsute: [2.0.0p15](https://github.com/chrisss404/check-mk-arm/releases/tag/2.0.0p12)
* Checkmk 2.0.0 for Ubuntu 20.10 Groovy: [2.0.0p15](https://github.com/chrisss404/check-mk-arm/releases/tag/2.0.0p12)
* Checkmk 2.0.0 for Ubuntu 20.04 Focal: [2.0.0p15](https://github.com/chrisss404/check-mk-arm/releases/tag/2.0.0p12)

### Build Checkmk from sources

    # build a specific version of Checkmk targeting Buster, e.g.: 2.0.0p1
    INSTALL_DEPENDENCIES=1 bash build_check_mk_buster32.sh <version>

    # build a specific version of Checkmk targeting Groovy, e.g.: 2.0.0p1
    bash build_check_mk_groovy64.sh <version>

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

    cp omd/packages/Python3/Python3.make omd/packages/Python3/Python3.make_v2
    vim omd/packages/Python3/Python3.make_v2
    +                CFLAGS="${CFLAGS} -fno-semantic-interposition" \
    -                LDFLAGS="-Wl,--rpath,/omd/versions/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/lib $(PACKAGE_OPENSSL_LDFLAGS)"
    +                LDFLAGS="-Wl,--rpath,/omd/versions/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/lib -fno-semantic-interposition $(PACKAGE_OPENSSL_LDFLAGS)"
    diff -u omd/packages/Python3/Python3.make omd/packages/Python3/Python3.make_v2 > ../python-make-add-fno-semantic-interposition.patch

#### Set system architecture to aarch64 in python build

    cp omd/packages/Python3/Python3.make omd/packages/Python3/Python3.make_v2
    vim omd/packages/Python3/Python3.make_v2
    -            $(PACKAGE_PYTHON3_PYTHONPATH)/_sysconfigdata__linux_x86_64-linux-gnu.py
    +            $(PACKAGE_PYTHON3_PYTHONPATH)/_sysconfigdata__linux_aarch64-linux-gnu.py
    -            $(PACKAGE_PYTHON3_PYTHONPATH)/_sysconfigdata__linux_x86_64-linux-gnu.py
    +            $(PACKAGE_PYTHON3_PYTHONPATH)/_sysconfigdata__linux_aarch64-linux-gnu.py
    diff -u omd/packages/Python3/Python3.make omd/packages/Python3/Python3.make_v2 > ../python-make-set-aarch64-architecture.patch

#### Set system architecture to arm in python build

    cp omd/packages/Python3/Python3.make omd/packages/Python3/Python3.make_v2
    vim omd/packages/Python3/Python3.make_v2
    -            $(PACKAGE_PYTHON3_PYTHONPATH)/_sysconfigdata__linux_x86_64-linux-gnu.py
    +            $(PACKAGE_PYTHON3_PYTHONPATH)/_sysconfigdata__linux_arm-linux-gnueabihf.py
    -            $(PACKAGE_PYTHON3_PYTHONPATH)/_sysconfigdata__linux_x86_64-linux-gnu.py
    +            $(PACKAGE_PYTHON3_PYTHONPATH)/_sysconfigdata__linux_arm-linux-gnueabihf.py
    diff -u omd/packages/Python3/Python3.make omd/packages/Python3/Python3.make_v2 > ../python-make-set-arm-architecture.patch


## Checkmk for Raspberry Pi

On the [release](https://github.com/chrisss404/check-mk-arm/releases) page you can find deb packages targeting the following systems:

* [Raspberry Pi OS (32-bit)](https://www.raspberrypi.org/downloads/raspberry-pi-os/) (formerly Raspbian) "Bullseye" on a RPi 3 and 4
* [Ubuntu (64-bit)](https://ubuntu.com/download/raspberry-pi/) "Jammy" on a RPi 4
* [Ubuntu (64-bit)](https://ubuntu.com/download/raspberry-pi/) "Focal" on a RPi 4
* [Ubuntu (64-bit)](https://ubuntu.com/download/raspberry-pi/) "Impish" on a RPi 4 (EOL / last version will be 2.0.0.p25)
* [Ubuntu (64-bit)](https://ubuntu.com/download/raspberry-pi/) "Hirsute" on a RPi 4 (EOL / last version will be 2.0.0.p20)
* [Ubuntu (64-bit)](https://ubuntu.com/download/raspberry-pi/) "Groovy" on a RPi 4 (EOL / last version will be 2.0.0.p16)
* [Debian (64-bit)](https://raspi.debian.net/tested/) "Bullseye" on a RPi 4

##### The builds for Focal and Groovy are untested !
##### The build for Bullseye arm64 is untested !

If your system is listed you can follow the instructions from section [Install Checkmk to your RPi](#install-checkmk-to-your-rpi), otherwise please refer to section [Build Checkmk from sources](#build-checkmk-from-sources) to compile a package for your system.

The sources of Checkmk can be found here: https://github.com/tribe29/checkmk

![Checkmk](https://raw.github.com/chrisss404/check-mk-arm/master/data/check_mk.png)

### Recommended Configurations

##### Reduce the number of apache processes

Go to `Setup` > `General` > `Global settings` > `Site Management` and reduce the number at `Apache process tuning` to 5.

### Install Checkmk to your RPi

The following sections show how to download and install the DEB packages available from this repo. After the installation you could follow the [official user guide](https://docs.checkmk.com/latest/en/) to set it up and start your monitoring journey.

##### Raspberry Pi OS (32-bit) Bullseye

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.1.0p13 | grep browser_download_url | cut -d '"' -f 4 | grep bullseye_armhf.deb) 
    dpkg -i check-mk-raw-*.bullseye_armhf.deb
    apt-get install -f

##### Ubuntu (64-bit) Jammy

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.1.0p13 | grep browser_download_url | cut -d '"' -f 4 | grep jammy_arm64.deb) 
    dpkg -i check-mk-raw-*.jammy_arm64.deb
    apt-get install -f
    
##### Ubuntu (64-bit) Focal

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.1.0p13 | grep browser_download_url | cut -d '"' -f 4 | grep focal_arm64.deb) 
    dpkg -i check-mk-raw-*.focal_arm64.deb
    apt-get install -f

##### Ubuntu (64-bit) Impish

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.0.0p25 | grep browser_download_url | cut -d '"' -f 4 | grep impish_arm64.deb) 
    dpkg -i check-mk-raw-*.impish_arm64.deb
    apt-get install -f

##### Ubuntu (64-bit) Hirsute

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.0.0p20 | grep browser_download_url | cut -d '"' -f 4 | grep hirsute_arm64.deb) 
    dpkg -i check-mk-raw-*.hirsute_arm64.deb
    apt-get install -f
    
##### Ubuntu (64-bit) Groovy

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.0.0p16 | grep browser_download_url | cut -d '"' -f 4 | grep groovy_arm64.deb) 
    dpkg -i check-mk-raw-*.groovy_arm64.deb
    apt-get install -f

##### Debian (64-bit) Bullseye

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/tags/2.1.0p13 | grep browser_download_url | cut -d '"' -f 4 | grep bullseye_arm64.deb) 
    dpkg -i check-mk-raw-*.bullseye_arm64.deb
    apt-get install -f
    
### Package overview

##### Raspberry Pi OS (32-bit)

* Checkmk 2.1.0 for Raspberry Pi OS Bullseye: [2.1.0p13](https://github.com/chrisss404/check-mk-arm/releases/tag/2.1.0p13)
* Checkmk 2.0.0 for Raspberry Pi OS Bullseye: [2.0.0p25](https://github.com/chrisss404/check-mk-arm/releases/tag/2.0.0p25)
* Checkmk 2.0.0 for Raspberry Pi OS Buster: [2.0.0p17](https://github.com/chrisss404/check-mk-arm/releases/tag/2.0.0p17)
* Checkmk 1.6.0 for Raspberry Pi OS Buster: [1.6.0p22](https://github.com/chrisss404/check-mk-arm/releases/tag/1.6.0p22)
* Checkmk 1.5.0 for Raspberry Pi OS Buster: [1.5.0p22](https://github.com/chrisss404/check-mk-arm/releases/tag/1.5.0p22)
* Checkmk 1.5.0 for Raspberry Pi OS Stretch: [1.5.0p20](https://github.com/chrisss404/check-mk-arm/releases/tag/1.5.0p20)
* Checkmk 1.4.0 for Raspberry Pi OS Stretch: [1.4.0p35](https://github.com/chrisss404/check-mk-arm/releases/tag/1.4.0p35)

##### Ubuntu (64-bit)

* Checkmk 2.1.0 for Ubuntu 22.04 Jammy: [2.1.0p13](https://github.com/chrisss404/check-mk-arm/releases/tag/2.1.0p13)
* Checkmk 2.1.0 for Ubuntu 20.04 Focal: [2.1.0p13](https://github.com/chrisss404/check-mk-arm/releases/tag/2.1.0p13)
* Checkmk 2.0.0 for Ubuntu 21.10 Impish: [2.0.0p25](https://github.com/chrisss404/check-mk-arm/releases/tag/2.0.0p25)

* Checkmk 2.0.0 for Ubuntu 21.04 Hirsute: [2.0.0p20](https://github.com/chrisss404/check-mk-arm/releases/tag/2.0.0p20)
###### Because of EOL from hirsute version 2.0.0.p20 is the last version for it.

* Checkmk 2.0.0 for Ubuntu 20.10 Groovy: [2.0.0p16](https://github.com/chrisss404/check-mk-arm/releases/tag/2.0.0p16)
###### Version 2.0.0.p16 is the last version for groovy, because of EOL from groovy.

##### Debian (64-bit)

* Checkmk 2.1.0 for Debian Bullseye: [2.1.0p13](https://github.com/chrisss404/check-mk-arm/releases/tag/2.1.0p13)

### Build Checkmk from sources

    # build a specific version of Checkmk targeting Bullseye, e.g.: 2.1.0p2
    INSTALL_DEPENDENCIES=1 bash build_check_mk_bullseye32.sh <version>

    # build a specific version of Checkmk targeting Groovy, e.g.: 2.1.0p2
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

    cp omd/packages/Python/Python.make omd/packages/Python/Python.make_v2
    vim omd/packages/Python/Python.make_v2
    +	        CFLAGS="${CFLAGS} -fno-semantic-interposition" \
    -	        LDFLAGS="-Wl,--rpath,/omd/versions/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/lib $(PACKAGE_OPENSSL_LDFLAGS)"
    +	        LDFLAGS="-Wl,--rpath,/omd/versions/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/lib -fno-semantic-interposition $(PACKAGE_OPENSSL_LDFLAGS)"
    diff -u omd/packages/Python/Python.make omd/packages/Python/Python.make_v2 > ../python-make-add-fno-semantic-interposition.patch

#### Set system architecture to aarch64 in python build

    cp omd/packages/Python/Python.make omd/packages/Python/Python.make_v2
    vim omd/packages/Python/Python.make_v2
    -	    $(PACKAGE_PYTHON_PYTHONPATH)/_sysconfigdata__linux_x86_64-linux-gnu.py
    +	    $(PACKAGE_PYTHON_PYTHONPATH)/_sysconfigdata__linux_aarch64-linux-gnu.py
    -	    $(PACKAGE_PYTHON_PYTHONPATH)/_sysconfigdata__linux_x86_64-linux-gnu.py
    +	    $(PACKAGE_PYTHON_PYTHONPATH)/_sysconfigdata__linux_aarch64-linux-gnu.py
    diff -u omd/packages/Python/Python.make omd/packages/Python/Python.make_v2 > ../python-make-set-aarch64-architecture.patch

#### Set system architecture to arm in python build

    cp omd/packages/Python/Python.make omd/packages/Python/Python.make_v2
    vim omd/packages/Python/Python.make_v2
    -	    $(PACKAGE_PYTHON_PYTHONPATH)/_sysconfigdata__linux_x86_64-linux-gnu.py
    +	    $(PACKAGE_PYTHON_PYTHONPATH)/_sysconfigdata__linux_arm-linux-gnueabihf.py
    -	    $(PACKAGE_PYTHON_PYTHONPATH)/_sysconfigdata__linux_x86_64-linux-gnu.py
    +	    $(PACKAGE_PYTHON_PYTHONPATH)/_sysconfigdata__linux_arm-linux-gnueabihf.py
    diff -u omd/packages/Python/Python.make omd/packages/Python/Python.make_v2 > ../python-make-set-arm-architecture.patch

#### Explicitly link against libatomic in protobuf build

    cp omd/packages/protobuf/protobuf.make omd/packages/protobuf/protobuf.make_v2
    vim omd/packages/protobuf/protobuf.make_v2
    -	    echo -e '\nprotoc-static: $(protoc_OBJECTS) $(protoc_DEPENDENCIES) $(EXTRA_protoc_DEPENDENCIES)\n\tg++ -pthread -DHAVE_PTHREAD=1 -DHAVE_ZLIB=1 -Wall -Wno-sign-compare -static-libgcc -static-libstdc++ -s -o protoc google/protobuf/compiler/main.o -lpthread ./.libs/libprotoc.a ./.libs/libprotobuf.a' >> Makefile && \
    +	    echo -e '\nprotoc-static: $(protoc_OBJECTS) $(protoc_DEPENDENCIES) $(EXTRA_protoc_DEPENDENCIES)\n\tg++ -pthread -DHAVE_PTHREAD=1 -DHAVE_ZLIB=1 -Wall -Wno-sign-compare -static-libgcc -static-libstdc++ -s -o protoc google/protobuf/compiler/main.o -lpthread ./.libs/libprotoc.a ./.libs/libprotobuf.a -latomic' >> Makefile && \
    diff -u omd/packages/protobuf/protobuf.make omd/packages/protobuf/protobuf.make_v2 > ../protobuf-make-add-latomic.patch

#### Remove pbr from pipfile

    cp Pipfile Pipfile_v2
    vim Pipfile_v2
    -pbr = "==5.4.4"  # needed by jira
    diff -u Pipfile Pipfile_v2 > ../pipfile-remove-pbr.patch

#### Remove playwright from pipfile

    cp Pipfile Pipfile_v2
    vim Pipfile_v2
    -playwright = "==1.19.0"  # used for in-browser testing
    diff -u Pipfile Pipfile_v2 > ../pipfile-remove-playwright.patch

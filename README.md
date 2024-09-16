
## Updates discontinued

Great news, there is an official commitment to add support for certain ARM architectures by Checkmk: [Checkmk – our road to ARM support](https://checkmk.com/blog/checkmk-our-road-arm-support).
This could mean, that at some point the Raspberry Pi 5 and subsequent models could use native Checkmk packages.
In the meantime, you can continue to vote for the feature request: https://features.checkmk.com/suggestions/297317/arm-support-for-the-cee-and-cme.

Unfortunately, due to native ARM support on the horizon we have decided to retire this project (thank you [@martux69](https://github.com/martux69) for all your hard work supporting arm64 over all the years). 
This decision was based on the fact that keeping up with upstream changes has recently become increasingly time-consuming, additionally other (personal) things have become more important, so that there is no longer enough time. 

### There is, however, a fork of the project being maintained on a "best effort" basis at https://github.com/FloTheSysadmin/check-mk-arm. 

If anyone would like to take over, please reach out.

![Checkmk](https://raw.github.com/chrisss404/check-mk-arm/master/data/check_mk.png)

### Tips & General Information

##### Errors during installation

````
dpkg: error processing package check-mk-raw-* (--install):
 dependency problems - leaving unconfigured
Errors were encountered while processing:
 check-mk-raw-*
````
That's perfectly fine. Run `apt-get install -f` and the installation should complete successfully.

##### Raspberry Pi: use an HDD/SSD when running Checkmk

The `rrdcached` issues many small write requests which may harm your SD card, see: https://forum.checkmk.com/t/checkmk-on-raspberry-pi/27760/4

##### Raspberry Pi: reduce the number of apache processes

Go to `Setup` > `General` > `Global settings` > `Site Management` and reduce the number at `Apache process tuning` to 5.

##### Oracle Cloud Infrastructure: access web interface

In case of issues accessing the Checkmk web interface, check the pre-defined iptables rules, see: https://blog.meinside.dev/When-Oracle-Clouds-Ubuntu-Instance-Doesnt-Accept-Connections-to-Ports-Other-than-22/

### Build Checkmk from sources

    # build a specific version of Checkmk targeting Debian 32-bit, e.g.: 2.2.0p1
    INSTALL_DEPENDENCIES=1 bash build_check_mk_debian_32bit.sh <version>

    # build a specific version of Checkmk targeting Ubuntu 64-bit, e.g.: 2.1.0p21
    INSTALL_DEPENDENCIES=1 bash build_check_mk_ubuntu_64bit.sh <version>

### Install Checkmk to your device

Build or get a deb package that targets your system and install it as shown below, then follow the [official user guide](https://docs.checkmk.com/latest/en/) to set everything up.

    dpkg -i check-mk-raw-*.deb
    apt-get update && apt-get install -f

### Patches

#### Allow empty pathhash items

    cp scripts/create_build_environment_variables.py scripts/create_build_environment_variables.py_v2
    vim scripts/create_build_environment_variables.py_v2
    -    if checksums and all(v == "--" for k, v in checksums):
    -        raise RuntimeError(
    -            "All provided 'pathhash' items result in emtpy hashes."
    -            " This is considerd to be an error."
    -        )
    diff -u scripts/create_build_environment_variables.py scripts/create_build_environment_variables.py_v2 > ../create_build_environment_variables-allow-empty-pathhash.patch

#### Use official python mirror

    cp defines.make defines.make_v2
    vim defines.make_v2
    -# By default our internal Python mirror is used.
    -# To use the official Python mirror, please export `USE_EXTERNAL_PIPENV_MIRROR=true`.
    -EXTERNAL_PYPI_MIRROR := https://pypi.python.org/simple
    -INTERNAL_PYPI_MIRROR :=  https://devpi.lan.tribe29.com/root/pypi
    -
    -ifeq (true,${USE_EXTERNAL_PIPENV_MIRROR})
    -PIPENV_PYPI_MIRROR  := $(EXTERNAL_PYPI_MIRROR)
    -else
    -PIPENV_PYPI_MIRROR  := $(INTERNAL_PYPI_MIRROR)
    -endif
    +PIPENV_PYPI_MIRROR := https://pypi.python.org/simple
    diff -u defines.make defines.make_v2 > ../defines.make-use-official-python-mirror.patch

#### Fix heirloom-mailx source url

    cp omd/packages/heirloom-mailx/heirloom-mailx_http.bzl omd/packages/heirloom-mailx/heirloom-mailx_http.bzl_v2
    vim omd/packages/heirloom-mailx/heirloom-mailx_http.bzl_v2
    -            "https://ftp.debian.org/debian/pool/main/h/heirloom-mailx/heirloom-mailx_" + HEIRLOOMMAILX_VERSION + ".orig.tar.gz",
    -            "https://artifacts.lan.tribe29.com/repository/upstream-archives/heirloom-mailx_" + HEIRLOOMMAILX_VERSION + ".orig.tar.gz",
    +            "http://archive.ubuntu.com/ubuntu/pool/universe/h/heirloom-mailx/heirloom-mailx_" + HEIRLOOMMAILX_VERSION + ".orig.tar.gz",
    diff -u omd/packages/heirloom-mailx/heirloom-mailx_http.bzl omd/packages/heirloom-mailx/heirloom-mailx_http.bzl_v2 > ../heirloom-mailx-fix-source-url.patch

#### Adapt makefile target ran-npm

    cp Makefile Makefile_v2
    vim Makefile_v2
    -        npm --version | grep "^$(NPM_VERSION)\." >/dev/null 2>&1
    -        node --version | grep "^v$(NODEJS_VERSION)\." >/dev/null 2>&1
    -        npm ci --yes --audit=false --unsafe-perm $$REGISTRY
    +        npm install
    diff -u Makefile Makefile_v2 > ../Makefile-adapt-ran-npm-target.patch

#### Reduce webpack memory consumption

    cp Makefile Makefile_v2
    vim Makefile_v2
    +.ran-webpack: export NODE_OPTIONS := --max-old-space-size=2048
    diff -u Makefile Makefile_v2 > ../Makefile-reduce-webpack-memory-consumption.patch

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
    -PYTHON_SYSCONFIGDATA := _sysconfigdata__linux_x86_64-linux-gnu.py
    +PYTHON_SYSCONFIGDATA := _sysconfigdata__linux_aarch64-linux-gnu.py
    diff -u omd/packages/Python/Python.make omd/packages/Python/Python.make_v2 > ../python-make-set-aarch64-architecture.patch

#### Set system architecture to arm in python build

    cp omd/packages/Python/Python.make omd/packages/Python/Python.make_v2
    vim omd/packages/Python/Python.make_v2
    -PYTHON_SYSCONFIGDATA := _sysconfigdata__linux_x86_64-linux-gnu.py
    +PYTHON_SYSCONFIGDATA := _sysconfigdata__linux_arm-linux-gnueabihf.py
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
    -pbr = "==5.11.0"  # needed by jira
    diff -u Pipfile Pipfile_v2 > ../pipfile-remove-pbr.patch

#### Remove playwright from pipfile

    cp Pipfile Pipfile_v2
    vim Pipfile_v2
    -playwright = "==1.30.0"  # used for in-browser testing
    diff -u Pipfile Pipfile_v2 > ../pipfile-remove-playwright.patch

#### Update pymssql version in pipfile

    cp Pipfile Pipfile_v2
    vim Pipfile_v2
    -pymssql = "==2.2.7"  # needed by check_sql active check
    +pymssql = "==2.2.8"  # needed by check_sql active check
    diff -u Pipfile Pipfile_v2 > ../pipfile-update-pymssql.patch

#### Fix xmlsec1 source url

    cp omd/packages/xmlsec1/xmlsec1_http.bzl omd/packages/xmlsec1/xmlsec1_http.bzl_v2
    vim omd/packages/xmlsec1/xmlsec1_http.bzl_v2
    -            "https://www.aleksey.com/xmlsec/download/xmlsec1-" + XMLSEC1_VERSION + ".tar.gz",
    -            "https://artifacts.lan.tribe29.com/repository/upstream-archives/xmlsec1-" + XMLSEC1_VERSION + ".tar.gz",
    +            "https://www.aleksey.com/xmlsec/download/older-releases/xmlsec1-" + XMLSEC1_VERSION + ".tar.gz",
    diff -u omd/packages/xmlsec1/xmlsec1_http.bzl omd/packages/xmlsec1/xmlsec1_http.bzl_v2 > ../xmlsec1-fix-source-url.patch


## Check_MK for RaspberryPi

This build is tested on Raspberry Pi 1 and 3, even though it runs on the first edition, it is not recommended. Use the third edition for a decent user experience. 

### Install Check_MK on Raspbian

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/latest | grep browser_download_url | cut -d '"' -f 4) 
    dpkg -i check-mk-raw-*_armhf.deb
    apt-get install -f

![Check_MK](https://raw.github.com/chrisss404/check-mk-arm/master/data/check_mk.png)

### Build

    bash build_check_mk.sh 1.5.0p2

### Create Patches

#### Remove shared option from python build

    cp omd/packages/python/Makefile omd/packages/python/Makefile_v2
    vim omd/packages/python/Makefile_v2
    -            --enable-shared \
    diff -u omd/packages/python/Makefile omd/packages/python/Makefile_v2 > ../python-Makefile.patch

#### Disable optimization for python build

    cp omd/packages/python/Makefile omd/packages/python/Makefile_v2
    vim omd/packages/python/Makefile_v2
    -            OPTI="--enable-optimizations" ; \
    +            OPTI="" ; \
    diff -u omd/packages/python/Makefile omd/packages/python/Makefile_v2 > ../python-Makefile-disable-optimization.patch

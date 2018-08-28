
## Check_MK for RaspberryPi

This build is tested on Raspberry Pi 1 and 3, even though it runs on the first edition, it is not recommended. Use the third edition for a decent user experience. 

### Install Check_MK on Raspbian

    curl -LO $(curl -s https://api.github.com/repos/chrisss404/check-mk-arm/releases/latest | grep browser_download_url | cut -d '"' -f 4)
    dpkg -i check-mk-raw-1.4.0p*_0.stretch_armhf.deb
    apt-get install -f

![Check_MK](https://raw.github.com/chrisss404/check-mk-arm/master/data/check_mk.jpg)

### Build

    bash build_check_mk.sh 1.4.0p35

### Create Patches

#### Increase timeout for maximum extraction time

    cp packages/perl-modules/lib/BuildHelper.pm packages/perl-modules/lib/BuildHelper_v2.pm
    vim packages/perl-modules/lib/BuildHelper_v2.pm
    -    alarm(120); # single module should not take longer than 1 minute
    +    alarm(1200); # single module should not take longer than 1 minute
    diff -u packages/perl-modules/lib/BuildHelper.pm packages/perl-modules/lib/BuildHelper_v2.pm > ../BuildHelper.patch

#### Remove navicli, because of missing ARM support

    cp Makefile Makefile_v2
    vim Makefile_v2
    -	 navicli \
    diff -u Makefile Makefile_v2 > ../Makefile.patch

#### Add ssl compatibility headers

    cp packages/nrpe/Makefile packages/nrpe/Makefile_v2
    vim packages/nrpe/Makefile_v2
    -        cd $(DIR) ; ./configure $(CONFIGUREOPTS)
    +        cd $(DIR) ; ./configure $(CONFIGUREOPTS) ; echo "#include \"../../libssl_compat.h\"" > temp.h ; cat include/dh.h >> temp.h ; mv temp.h include/dh.h
    diff -u packages/nrpe/Makefile packages/nrpe/Makefile_v2 > ../nrpe-Makefile.patch

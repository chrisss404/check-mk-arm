FROM arm64v8/ubuntu:jammy

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 LANG=C.UTF-8 PATH="/opt/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update -y

RUN apt-get remove -y \
    libpython3.10:arm64 \
    libpython3.10-dev:arm64 \   
    libpython3.10-minimal:arm64 \
    libpython3.10-stdlib:arm64 \
    python3.10 \
    python3.10-dev \
    python3.10-minimal

RUN apt-get update \
    && apt-get install -y \
    alien \
    apache2 \
    apache2-dev \
    apt-utils \
    aptitude \
    autoconf \
    bear \
    binutils \
    build-essential \
    chrpath \
    clang-12 \
    clang-format-12 \
    clang-tidy-12 \
    clang-tools-12 \
    clangd-12 \
    cppcheck \
    clang-tidy \
    cmake \
    curl \
    dialog \
    direnv \
    devscripts \
    dnsutils \
    doxygen \
    dpatch \
    enchant-2 \
    figlet \
    flex \
    freetds-bin \
    freetds-dev \
    g++ \
    g++-12 \
    gawk \
    gcc \
    gcc-12 \
    gdebi \
    gettext \
    git \
    git-buildpackage \
    graphviz \
    gtk-doc-tools \
    iputils-ping \
    ksh \
    libclang-12-dev \
    libclang-common-12-dev \
    libclang1-12 \
    libcurl4-openssl-dev \
    libenchant-2-2 \
    libevent-dev \
    libffi-dev \
    libfreeradius-dev \
    libgd-dev \
    libglib2.0-dev \
    libgnutls28-dev \
    libgsf-1-dev \
    libjpeg-dev \
    libkrb5-dev \
    libldap2-dev \
    libltdl-dev \
    libmcrypt-dev \
    libmysqlclient-dev \
    libncurses5-dev \
    libopenblas-dev \
    libpango1.0-dev \
    libpcap-dev \
    libperl-dev \
    libpq-dev \
    libreadline-dev \
    librrd-dev \
    libsasl2-dev \
    libsodium-dev \ 
    libsqlite3-dev \
    libssl-dev \
    libstdc++-12-dev \
    libtool \
    libxml2 \
    libxml2-dev \
    libxmlsec1-dev \
    libxmlsec1-openssl \
    lldb \
    lld \
    lsb-release \
    make \
    mono-complete \
    mono-xbuild \
    nodejs \
    npm \
    nullmailer \
    openssh-client \
    openssl \
    patch \
    patchelf \
    php-common \
    pngcrush \
    p7zip-full \
    rpcbind \
    rpm \
    rrdtool \
    rsync \
    shellcheck \
    smbclient \
    software-properties-common \
    strace \
    sudo \
    tar \
    texinfo \
    tk-dev \
    uuid-dev \
    vim \
    valgrind \
    xmlsec1 \ 
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get remove -y nodejs libnode-dev libnode72
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get update -y && apt-get install -y nodejs

RUN apt-get remove -y cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN add-apt-repository 'deb https://apt.kitware.com/ubuntu/ jammy main'
RUN apt-get update -y && apt-get install -y cmake

RUN apt-get autoremove -y

RUN apt-get install -y python3.11 \
    libpython3.11 \
    libpython3.11-dev \
    python3.11-dev \
    python3.11-distutils \
    python3.11-venv \
    python3-setuptools \
    python3-sphinx \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
RUN python3 -V

#RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 
RUN python3.11 -m ensurepip
RUN pip3 -V

RUN cp /usr/local/bin/pip3 /usr/bin
RUN cp /usr/local/bin/pip3.11 /usr/bin

RUN python3.11 -m pip install --upgrade pip
RUN pip3 install pipenv
RUN cp /usr/local/bin/pipenv* /usr/bin/
RUN cp /usr/local/bin/virtualenv* /usr/bin/

COPY bazel-5.3.2-linux-arm64 /usr/bin/bazel
RUN chmod 755 /usr/bin/bazel

ENV DISTRO="ubuntu-22.04" DISTRO_CODE="jammy"

WORKDIR /opt/build-mk
RUN mkdir /opt/build-mk/debs
COPY build_check_mk.sh .
COPY *.patch ./

ENTRYPOINT ["./build_check_mk.sh"]

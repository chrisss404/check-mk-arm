FROM arm64v8/debian:bookworm-slim

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 LANG=C.UTF-8 PATH="/opt/bin:${PATH}"
RUN mkdir -p /usr/share/man/man1

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
    cargo \
    chrpath \
    clang-15 \
    clang-format-15 \
    clang-tidy-15 \
    clang-tools-15 \
    clangd-15 \
    cppcheck \
    clang-tidy \
    cmake \
    curl \
    dialog \
    direnv \
    devscripts \
    dnsutils \
    doxygen \
    enchant-2 \
    figlet \
    flex \
    freetds-bin \
    freetds-dev \
    g++ \
    gawk \
    gcc \
    gdebi \
    gettext \
    git \
    git-buildpackage \
    graphviz \
    gtk-doc-tools \
    iputils-ping \
    ksh \
    libclang-15-dev \
    libclang-common-15-dev \
    libclang1-15 \
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
    libmariadb-dev-compat \
    libmariadb-dev \
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
    rustc \
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
    zstd \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get upgrade -y

RUN echo "Package: nodejs" >> /etc/apt/preferences.d/preferences && \
    echo "Pin: origin deb.nodesource.com" >> /etc/apt/preferences.d/preferences && \
    echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/preferences

RUN apt-get remove -y nodejs libnode-dev libnode72
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update -y && apt-get install -y nodejs

RUN apt-get remove -y cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4-linux-aarch64.sh && chmod 755 cmake-3.26.4-linux-aarch64.sh
RUN ./cmake-3.26.4-linux-aarch64.sh --skip-license --prefix=/usr

RUN apt-get autoremove -y

#RUN wget https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tgz && tar xzf Python-3.11.3.tgz
#RUN cd Python-3.11.3 && ./configure --enable-optimizations && make install
#RUN python3 -V

RUN apt-get install -y python3 \
    libpython3.11 \
    libpython3-dev \
    python3-dev \
    python3-distutils \
    python3-pip \
    python3-venv \
    python3-setuptools \
    python3-sphinx \
    pipenv \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -V
RUN pip3 -V

#RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 
#RUN python3.11 -m ensurepip
#RUN pip3 -V

#RUN cp /usr/local/bin/pip3 /usr/bin
#RUN cp /usr/local/bin/pip3.11 /usr/bin

#RUN python3 -m pip install --upgrade pip
#RUN pip3 install pipenv
#RUN cp /usr/local/bin/pipenv* /usr/bin/
#RUN cp /usr/local/bin/virtualenv* /usr/bin/

COPY bazel-5.3.2-linux-arm64 /usr/bin/bazel
RUN chmod 755 /usr/bin/bazel

#RUN ln -sf /usr/bin/g++ /usr/bin/g++-12

ENV DISTRO="debian" DISTRO_CODE="bookworm"

RUN mkdir -p /opt/build-mk/debs
RUN mkdir -p /opt/build-mk/patches

ENTRYPOINT ["/opt/build-mk/patches/build_check_mk.sh"]

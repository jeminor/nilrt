#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM buildpack-deps:buster

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# extra dependencies (over what buildpack-deps already includes)
RUN apt-get update && apt-get install -y --no-install-recommends \
		libbluetooth-dev \
		tk-dev \
	&& rm -rf /var/lib/apt/lists/*

ENV GPG_KEY 0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D
ENV PYTHON_VERSION 3.6.12

RUN set -ex \
	\
	&& wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
	&& wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \
	&& rm -rf "$GNUPGHOME" python.tar.xz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
	\
	&& cd /usr/src/python \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip \
	&& make -j "$(nproc)" \
# setting PROFILE_TASK makes "--enable-optimizations" reasonable: https://bugs.python.org/issue36044 / https://github.com/docker-library/python/issues/160#issuecomment-509426916
		PROFILE_TASK='-m test.regrtest --pgo \
			test_array \
			test_base64 \
			test_binascii \
			test_binhex \
			test_binop \
			test_bytes \
			test_c_locale_coercion \
			test_class \
			test_cmath \
			test_codecs \
			test_compile \
			test_complex \
			test_csv \
			test_decimal \
			test_dict \
			test_float \
			test_fstring \
			test_hashlib \
			test_io \
			test_iter \
			test_json \
			test_long \
			test_math \
			test_memoryview \
			test_pickle \
			test_re \
			test_set \
			test_slice \
			test_struct \
			test_threading \
			test_time \
			test_traceback \
			test_unicode \
		' \
	&& make install \
	&& rm -rf /usr/src/python \
	\
	&& find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) \) \
			-o \( -type f -a -name 'wininst-*.exe' \) \
		\) -exec rm -rf '{}' + \
	\
	&& ldconfig \
	\
	&& python3 --version

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 20.2.2
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/5578af97f8b2b466f4cdbebe18a3ba2d48ad1434/get-pip.py
ENV PYTHON_GET_PIP_SHA256 d4d62a0850fe0c2e6325b2cc20d818c580563de5a2038f917e3cb0e25280b4d1

RUN set -ex; \
	\
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum --check --strict -; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==$PYTHON_PIP_VERSION" \
	; \
	pip --version; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' +; \
	rm -f get-pip.py

# Everything above here comes from a Python docker build
# Everything below here come from the existing Dockerfile
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Leave this out until we need some of these things
# RUN sed -i 's/stretch main/stretch main contrib/' /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --assume-yes apt-utils

# Install OE dependencies
RUN apt-get update && apt-get install --assume-yes \
	bc \
	build-essential \
	ccache \
	chrpath \
	cpio \
	cvs \
	desktop-file-utils \
	diffstat \
	gawk \
	gcc-multilib \
	gdb \
	genisoimage \
	git-core \
	gnupg2 \
	help2man \
	info \
	iputils-ping \
	libc6-dbg \
	libguestfs-tools \
	libpulse-dev \
	libsdl1.2-dev \
	linux-image-amd64 \
	locales \
	pigz \
	pkg-config \
	qemu-kvm \
	qemu-system-x86 \
	qemu-utils \
	rsync \
	socat \
	strace \
	subversion \
	sudo \
	texi2html \
	texinfo \
	unzip \
	uuid-runtime \
	vim \
	wget \
	xmlstarlet \
	zip

# Install virtualbox from upstream because it's not available in debian 9
# RUN echo 'deb http://download.virtualbox.org/virtualbox/debian stretch contrib' > /etc/apt/sources.list.d/virtualbox.list
# RUN wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
# RUN apt-key add oracle_vbox_2016.asc
# RUN rm oracle_vbox_2016.asc
# RUN apt-get update && apt-get install --assume-yes virtualbox-6.0

RUN dpkg-reconfigure -f noninteractive locales
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Cleanup image of unneeded packages to reduce size

RUN apt-get autoremove --yes && apt-get clean --yes
RUN rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
RUN rm -f \
	/var/cache/apt/*.bin \
	/var/cache/apt/archives/*.deb \
	/var/cache/apt/archives/partial/*.deb

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Remove this since it's really large 
COPY agent.tar.gz /agent.tar.gz

RUN cd /srv && tar xvfz ../agent.tar.gz

RUN rm /usr/bin/python3
RUN rm /usr/local/bin/python3
COPY python3.in /usr/local/bin/python3 
RUN chmod a+x /usr/local/bin/python3

COPY p4 /usr/local/bin/p4

# Just add a play user account for now
RUN useradd jminor
RUN mkdir -p /home/jminor
RUN chown jminor:jminor /home/jminor

# Missing some p4 auth stuff

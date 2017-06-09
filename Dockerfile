FROM centos:7
MAINTAINER yvijayak <yvijayak@adobe.com>

ENV PYTHON_VERSION 3.6.1

# Install basic system libraries
RUN yum -y update && yum install -y libsqlite3-dev \
  bzip2-devel \
  ca-certificates \
  curl \
  gcc \
  openssl-devel \
  tar \
  wget \
  xz \
  zlib-dev \
  make


# Install Python
RUN mkdir -p /usr/src/python \
  && wget "https://www.python.org/ftp/python/3.6.1/Python-$PYTHON_VERSION.tar.xz" -O python.tar.xz \
  && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
  && rm python.tar.xz \
  && cd /usr/src/python \
  && ./configure --prefix=/usr/local --enable-shared --enable-loadable-sqlite-extensions --enable-unicode=ucs4 LDFLAGS="-Wl,-rpath /usr/local/lib" \
  && make -j$(nproc) \
  && make altinstall \
  && ln -sf /usr/local/bin/python3.6 /usr/local/bin/python \
  && find /usr/local \
    \( -type d -a -name test -o -name tests \) \
    -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    -exec rm -rf '{}' + \
  && rm -rf /usr/src/python

# Install setuptools, pip and virtualenv
ENV PYTHON_PIP_VERSION 9.0.1

RUN set -ex; \
	\
	wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
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
			\( -type d -a -name test -o -name tests \) \
			-o \
			\( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		\) -exec rm -rf '{}' +; \
	rm -f get-pip.py
RUN pip3 install --upgrade virtualenv

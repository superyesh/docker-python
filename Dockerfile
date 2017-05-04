FROM centos:7
MAINTAINER yvijayak <yvijayak@adobe.com>

ENV PYTHON_VERSION 2.7.8

# Install basic system libraries
RUN yum -y update && yum install -y \
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
  && wget "https://www.python.org/ftp/python/2.7.8/Python-$PYTHON_VERSION.tar.xz" -O python.tar.xz \
  && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
  && rm python.tar.xz \
  && cd /usr/src/python \
  && ./configure --prefix=/usr/local --enable-shared --enable-unicode=ucs4 LDFLAGS="-Wl,-rpath /usr/local/lib" \
  && make -j$(nproc) \
  && make altinstall \
  && ln -sf /usr/local/bin/python2.7 /usr/local/bin/python \
  && find /usr/local \
    \( -type d -a -name test -o -name tests \) \
    -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    -exec rm -rf '{}' + \
  && rm -rf /usr/src/python

# Install setuptools, pip and virtualenv
RUN wget "https://bootstrap.pypa.io/ez_setup.py" -O - | python \
  && curl ""https://bootstrap.pypa.io/get-pip.py"" | python - \
  && pip install virtualenv

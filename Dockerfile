FROM ubuntu:16.04
MAINTAINER Bo Ji <bo.ji@wustl.edu>
# Set up for make get-deps


RUN mkdir /app
WORKDIR /app

# bootstrap build dependencies
# Concatentating these command together will create only 1 docker image layer
# fewer image layers are better / smaller
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https && \
    echo "deb [trusted=yes] https://gitlab.com/indraniel/ccdg-apt-repo/raw/master ccdg main" | tee -a /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get -y install \
     ccdg-samtools-1.3.1 \
     ccdg-picard-2.4.1 \ 
     build-essential \
     pkg-config \
     libbz2-dev \
     git-core \
     cmake \
     autoconf \
     liblist-moreutils-perl \
     libevent-dev \
     libdouble-conversion-dev \
     libgoogle-glog-dev \
     libgflags-dev \
     liblz4-dev \
     liblzma-dev \
     libsnappy-dev \
     make \
     zlib1g-dev \
     binutils-dev \
     libjemalloc-dev \
     libssl-dev \
     openssl \
     libreadline-dev \
     libicu-dev \
     libnss-sss \
     wget \
     libboost-all-dev \
     parallel \
      --no-install-recommends && \
    apt-get clean all

ENV PATH /opt/ccdg/samtools-1.3.1/bin:${PATH}
ENV PATH /opt/ccdg/picard-2.4.1/bin:${PATH}

    
RUN git clone --recursive https://github.com/DecodeGenetics/graphtyper.git graphtyper && \
cd /app/graphtyper  && \
mkdir -p /app/graphtyper/release-build && \
cd /app/graphtyper/release-build && \
cmake ..  && \
make -j4 graphtyper 

ENV SHELL /bin/bash

CMD ["/bin/bash"]


ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ARG COMPILER_VERSION=11

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get install -y -q --no-install-recommends \
        ca-certificates \
        cmake \
        gcc-${COMPILER_VERSION} \
        g++-${COMPILER_VERSION} \
        git \
        libgtest-dev \
        make \
        software-properties-common \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CC=/usr/bin/gcc-${COMPILER_VERSION}
ENV CXX=/usr/bin/g++-${COMPILER_VERSION}

RUN mkdir /kokkos && \
    cd /kokkos && \
    mkdir build install && \
    wget https://github.com/kokkos/kokkos/releases/download/4.4.01/kokkos-4.4.01.tar.gz && \
    tar -xzvf kokkos-4.4.01.tar.gz && \
    cmake -S kokkos-4.4.01 -B build -DCMAKE_INSTALL_PREFIX=install && \
    cd build && \
    make -j$(nproc) && \
    make install

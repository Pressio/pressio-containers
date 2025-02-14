# ubuntu-gnu-mpi

ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ARG COMPILER_VERSION=11
ARG CC=gcc-${COMPILER_VERSION}
ARG CXX=g++-${COMPILER_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get install -y -q --no-install-recommends \
        ca-certificates \
        cmake \
        gcc-${COMPILER_VERSION} \
        g++-${COMPILER_VERSION} \
        git \
        libeigen3-dev \
        libgtest-dev \
        libopenmpi-dev \
        make \
        openmpi-bin \
        software-properties-common \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/${CC} 10
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/${CXX} 10
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 20
RUN update-alternatives --set cc /usr/bin/gcc
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 20
RUN update-alternatives --set c++ /usr/bin/g++

ENV CC=/usr/bin/mpicc
ENV CXX=/usr/bin/mpic++
ENV MPIRUN=/usr/bin/mpirun

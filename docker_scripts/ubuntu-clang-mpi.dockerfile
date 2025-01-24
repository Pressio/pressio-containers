ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ARG COMPILER_VERSION=14

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get install -y -q --no-install-recommends \
        ca-certificates \
        clang-${COMPILER_VERSION} \
        cmake \
        git \
        libgtest-dev \
        libopenmpi-dev \
        make \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CC=/usr/bin/mpicc
ENV CXX=/usr/bin/mpic++
ENV FC=/usr/bin/mpifort
ENV F77=/usr/bin/mpifort
ENV F90=/usr/bin/mpifort
ENV MPIRUN=/usr/bin/mpirun

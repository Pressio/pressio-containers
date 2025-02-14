# ubuntu-clang-mpi

ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ARG COMPILER_VERSION=14
ARG CC=clang-${COMPILER_VERSION}
ARG CXX=clang++-${COMPILER_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get install -y -q --no-install-recommends \
        ca-certificates \
        clang-${COMPILER_VERSION} \
        cmake \
        git \
        libeigen3-dev \
        libgtest-dev \
        libopenmpi-dev \
        make \
        openmpi-bin \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN update-alternatives --install /usr/bin/clang clang /usr/bin/${CC} 10
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/${CXX} 10
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 20
RUN update-alternatives --set cc /usr/bin/clang
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 20
RUN update-alternatives --set c++ /usr/bin/clang++

ENV OMPI_CC=/usr/bin/clang
ENV OMPI_CXX=/usr/bin/clang++

ENV CC=/usr/bin/mpicc
ENV CXX=/usr/bin/mpic++
ENV MPIRUN=/usr/bin/mpirun

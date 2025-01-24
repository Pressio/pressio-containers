ARG FEDORA_VERSION=39
FROM fedora:${FEDORA_VERSION}

RUN dnf update -y && \
    dnf install -y \
        clang \
        cmake \
        git \
        gtest-devel \
        hostname \
        make \
        openmpi \
        openmpi-devel \
        wget && \
    dnf clean all

ENV CC=/usr/bin/mpicc
ENV CXX=/usr/bin/mpic++
ENV FC=/usr/bin/mpifort
ENV F77=/usr/bin/mpifort
ENV F90=/usr/bin/mpifort
ENV MPIRUN=/usr/bin/mpirun

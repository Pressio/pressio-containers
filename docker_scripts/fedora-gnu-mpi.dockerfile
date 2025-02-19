ARG FEDORA_VERSION=39
FROM fedora:${FEDORA_VERSION}

RUN dnf update -y && \
    dnf install -y \
        cmake \
        g++ \
        gcc \
        git \
        gtest-devel \
        hostname \
        make \
        openmpi \
        openmpi-devel \
        wget && \
    dnf clean all

ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++

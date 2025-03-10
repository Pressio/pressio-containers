ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ARG TRILINOS_VERSION=0dc4553

COPY scripts/install_trilinos.sh /install_trilinos.sh
RUN chmod +x /install_trilinos.sh && \
    /install_trilinos.sh ${TRILINOS_VERSION}

ENV CC=/usr/bin/mpicc
ENV CXX=/usr/bin/mpic++
ENV FC=/usr/bin/mpifort
ENV F77=/usr/bin/mpifort
ENV F90=/usr/bin/mpifort
ENV MPIRUN=/usr/bin/mpirun

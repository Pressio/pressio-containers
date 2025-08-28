ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ARG TRILINOS_VERSION=trilinos-release-16-1-0

COPY ../scripts/install_trilinos2.sh /install_trilinos2.sh
RUN chmod +x /install_trilinos2.sh && \
    /install_trilinos2.sh ${TRILINOS_VERSION}

ENV CC=/usr/bin/mpicc
ENV CXX=/usr/bin/mpic++
ENV MPIRUN=/usr/bin/mpirun

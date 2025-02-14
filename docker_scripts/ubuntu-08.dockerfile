ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ARG TRILINOS_VERSION=5bbda25

COPY ../scripts/install_trilinos.sh /install_trilinos.sh
RUN chmod +x /install_trilinos.sh && \
    /install_trilinos.sh ${TRILINOS_VERSION}

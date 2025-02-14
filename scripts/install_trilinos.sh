#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <trilinos-version>"
    exit 1
fi

TRILINOS_VERSION=$1
CMAKE_VERSION=3.27.8
COMPILER_VERSION=11
CC=gcc-${COMPILER_VERSION}
CXX=g++-${COMPILER_VERSION}
GFORTRAN=gfortran-${COMPILER_VERSION}

# Update and install dependencies
apt-get update -y -q
apt-get upgrade -y -q
apt-get install -y -q --no-install-recommends \
        ca-certificates \
        git \
        libeigen3-dev \
        libgtest-dev \
        liblapack-dev \
        libopenblas-dev \
        libopenmpi-dev \
        make \
        python3 \
        python3-numpy \
        wget \
        $CC $CXX $GFORTRAN
apt-get clean
rm -rf /var/lib/apt/lists/*

# Install CMake
wget -O cmake.sh https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-${CMAKE_VERSION}-Linux-x86_64.sh
sh cmake.sh --skip-license --exclude-subdir --prefix=/usr/local/
rm cmake.sh

# Setup compiler alternatives
update-alternatives --install /usr/bin/gcc gcc /usr/bin/${CC} 10
update-alternatives --install /usr/bin/g++ g++ /usr/bin/${CXX} 10
update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/${GFORTRAN} 10
update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 20
update-alternatives --set cc /usr/bin/gcc
update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 20
update-alternatives --set c++ /usr/bin/g++
update-alternatives --install /usr/bin/fortrann fortrann /usr/bin/gfortran 20
update-alternatives --set fortrann /usr/bin/gfortran

# Set environment variables
export CC=/usr/bin/mpicc
export CXX=/usr/bin/mpic++
export FC=/usr/bin/mpifort
export F77=/usr/bin/mpifort
export F90=/usr/bin/mpifort
export MPIRUN=/usr/bin/mpirun

# Clone and build Trilinos
mkdir /trilinos && cd /trilinos

git clone https://github.com/trilinos/Trilinos.git .
git checkout ${TRILINOS_VERSION}
mkdir build install

cmake -B /trilinos/build \
    -D CMAKE_BUILD_TYPE=Release \
    -D BUILD_SHARED_LIBS=ON \
    -D TPL_FIND_SHARED_LIBS=ON \
    -D Trilinos_LINK_SEARCH_START_STATIC=OFF \
    -D CMAKE_VERBOSE_MAKEFILE=TRUE \
    -D TPL_ENABLE_MPI=ON \
    -D MPI_C_COMPILER=/usr/bin/mpicc \
    -D MPI_CXX_COMPILER=/usr/bin/mpic++ \
    -D MPI_USE_COMPILER_WRAPPERS=ON \
    -D Trilinos_ENABLE_Fortran=ON \
    -D MPI_Fortran_COMPILER=/usr/bin/mpifort \
    -D Trilinos_ENABLE_TESTS=OFF \
    -D Trilinos_ENABLE_EXAMPLES=OFF \
    -D TPL_ENABLE_BLAS=ON \
    -D TPL_ENABLE_LAPACK=ON \
    -D Kokkos_ENABLE_SERIAL=ON \
    -D Kokkos_ENABLE_THREADS=OFF \
    -D Kokkos_ENABLE_OPENMP=OFF \
    -D Kokkos_ENABLE_DEPRECATED_CODE=OFF \
    -D Trilinos_ENABLE_ALL_PACKAGES=OFF \
    -D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF \
    -D Trilinos_ENABLE_Teuchos=ON \
    -D Trilinos_ENABLE_Tpetra=ON \
    -D Tpetra_ENABLE_DEPRECATED_CODE=OFF \
    -D Tpetra_ENABLE_TSQR=ON \
    -D Trilinos_ENABLE_Ifpack2=ON \
    -D Trilinos_ENABLE_ROL=ON \
    -D CMAKE_INSTALL_PREFIX=/trilinos/install \
    -S /trilinos

cd /trilinos/build
make -j$(nproc)
make install

sed -i -e '$alocalhost slots=4' /etc/openmpi/openmpi-default-hostfile

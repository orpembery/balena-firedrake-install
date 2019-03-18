#!/bin/bash

###
# Setup
###

# Default modules to load
module load git/2.5.1
module load intel/mpi/64/18.0.128
module load intel/mkl/64/11.3.3
module load boost/intel/1.57.0
module load htop
module load cmake/3.5.2
module load intel/compiler/64/18.0.128
module load slurm/17.11.7
#module load hdf5/gcc/1.8.17

# Set main to be scratch
MAIN=`pwd`

# Load python2
module load python/2.7.8

###
# Download and install PETSc
###
git clone https://github.com/firedrakeproject/petsc.git

export PETSC_ARCH=arch-python-linux-x86_64
unset PETSC_DIR
cd ./petsc

# Configure PETSc
./configure --with-cc=mpiicc --with-cxx=mpiicpc --with-fc=mpiifort --with-debugging=0 COPTFLAGS='-O3 -march=native -mtune=native' CXXOPTFLAGS='-O3 -march=native -mtune=native' FOPTFLAGS='-O3 -march=native -mtune=native' --with-shared-libraries=1 --with-debugging=0 --with-c2html=0 --download-fblaslapack --download-eigen --with-fortran-bindings=0 --download-chaco --download-metis --download-parmetis --download-scalapack --download-hypre --download-mumps --download-netcdf --download-hdf5 --download-pnetcdf --download-zlib

# Build PETSc
make -j 17 PETSC_DIR=${MAIN}/petsc PETSC_ARCH=arch-python-linux-x86_64 all

# REMOVE???
#make -j 17 PETSC_DIR=${MAIN}/petsc PETSC_ARCH=arch-python-linux-x86_64 install
# CHECK???
make -j 17 PETSC_DIR=${MAIN}/petsc PETSC_ARCH=arch-python-linux-x86_64 check
#make -j 17 PETSC_DIR=${MAIN}/petsc PETSC_ARCH=arch-python-linux-x86_64 streams


# Set PETSc directory
export PETSC_DIR=${MAIN}/petsc
cd ..

###
# Download and install python3
###
module unload python/2.7.8

# 3.6.3 was working
wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tar.xz
mkdir python3.7
tar -xvf Python-3.7.2.tar.xz -C ./python3.7 --strip-components=1
unset PYTHON_DIR
export PYTHON_DIR=${MAIN}/python3.7
cd ./python3.7

# Configure
# try with --with-tcltk-includes='-I/apps/python/intel/2018.1.023/intelpython3/include'
# and --with-tcltk-libs='-L/apps/python/intel/2018.1.023/intelpython3/lib -ltcl8.6 -ltk8.6'
export CC=icc
export CXX=icpc
export F90=ifort

#export 
export LDFLAGS=-L${MAIN}/openssl-1.1.1a
export CPPFLAGS=-I${MAIN}/openssl-1.1.1a
./configure --enable-shared --enable-ipv6 --with-ensurepip=yes --prefix=${PYTHON_DIR} CPPFLAGS=-I${PYTHON_DIR}/include LDFLAGS="-L${PYTHON_DIR}/lib -Wl,-rpath=${PYTHON_DIR}/lib,--no-as-needed" CFLAGS="-Wformat -Wformat-security -D_FORTIFY_SOURCE=2 -fstack-protector -O3 -fpic -fPIC" PKG_CONFIG_PATH=${PYTHON_DIR}/lib/pkgconfig --enable-optimizations

# Build Python3
make -j 17
make -j 17 install

# Add python to path
export PATH="${PYTHON_DIR}/bin:$PATH"
cd ..

# May need:
python3 -m ensurepip

###
# Download and install firedrake
###
wget https://raw.githubusercontent.com/firedrakeproject/firedrake/master/scripts/firedrake-install

export MPICC=mpiicc
export MPICXX=mpiicpc
export MPIF90=mpiifort

# remove???
#unset PETSC_ARCH

export INTEL_LICENSE_FILE=/cm/shared/licenses/intel/
### This line doesn't work, python3 complains about not being able to find encodings module, but then runs fine in terminal after

export CPATH=$CPATH:$MAIN/petsc/arch-python-linux-x86_64/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MAIN/petsc/arch-python-linux-x86_64/lib
export LDFLAGS=-L$MAIN/petsc/arch-python-linux-x86_64/lib

python3 -i firedrake-install --mpicc=mpiicc --mpicxx=mpiicpc --mpif90=mpiifort --no-package-manager --disable-ssh --honour-petsc-dir

# Add paths to .bashrc (only do this once!)
# echo PETSC_DIR=${MAIN}/petsc >> ~/.bashrc
# echo PATH="${PYTHON_DIR}/bin:$PATH" >> ~.bashrc

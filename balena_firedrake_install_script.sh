#!/bin/bash

# Script by Jack Betteridge, modified a little by Roshan Mathew and Owen Pembery

###
# Setup
###

# Default modules to load
module purge
module load git/2.5.1
module load intel/mpi/64/18.0.128
module load intel/mkl/64/11.3.3
module load boost/intel/1.57.0
module load htop
module load cmake/3.5.2
module load intel/compiler/64/18.0.128
module load slurm/17.11.7
#module load hdf5/gcc/1.8.17

# Set main to be working directory
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

# CHECK???
make -j 17 PETSC_DIR=${MAIN}/petsc PETSC_ARCH=arch-python-linux-x86_64 check

# Set PETSc directory
export PETSC_DIR=${MAIN}/petsc
cd ..

###
# Download and install python3
###
module unload python/2.7.8

wget https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz
mkdir python3
tar -xzvf Python-3.6.5.tgz -C ./python3 --strip-components=1
unset PYTHON_DIR
export PYTHON_DIR=${MAIN}/python3
cd ./python3

# Build Python3
make -j 17
make -j 17 install

# Add python to path
export PATH="${PYTHON_DIR}/bin:$PATH"
cd ..

# Remove references to inbuilt python - crashes otherwise
unset PYTHONHOME

# May need:
python3 -m ensurepip

###
# Download and install firedrake
###
wget https://raw.githubusercontent.com/firedrakeproject/firedrake/master/scripts/firedrake-install

export MPICC=mpiicc
export MPICXX=mpiicpc
export MPIF90=mpiifort

export INTEL_LICENSE_FILE=/cm/shared/licenses/intel/

export CPATH=$CPATH:$MAIN/petsc/arch-python-linux-x86_64/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MAIN/petsc/arch-python-linux-x86_64/lib
export LDFLAGS=-L$MAIN/petsc/arch-python-linux-x86_64/lib

python3 -i firedrake-install --mpicc=mpiicc --mpicxx=mpiicpc --mpif90=mpiifort --no-package-manager --disable-ssh --honour-petsc-dir


#!/bin/bash

# Default modules to load
module load git/2.5.1
module load intel/mpi/64/18.0.128
module load intel/mkl/64/11.3.3
module load boost/intel/1.57.0
module load htop
module load cmake/3.5.2
module load intel/compiler/64/18.0.128
module load slurm/17.11.7

# Need to set MAIN - should be the directory in which you installed Firedrake with the install script
MAIN=

export PETSC_ARCH=arch-python-linux-x86_64
export PETSC_DIR=${MAIN}/petsc
export PYTHON_DIR=${MAIN}/python3
export PATH="${PYTHON_DIR}/bin:$PATH"

export MPICC=mpiicc
export MPICXX=mpiicpc
export MPIF90=mpiifort
# Intel can never find its licence
export INTEL_LICENSE_FILE=/cm/shared/licenses/intel/
# Having I_MPI_FABRICS=shm:tmi breaks things
unset I_MPI_FABRICS

# Maybe req'd???
export CPATH=$CPATH:$MAIN/petsc/arch-python-linux-x86_64/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MAIN/petsc/arch-python-linux-x86_64/lib
export LDFLAGS=-L$MAIN/petsc/arch-python-linux-x86_64/lib

# Possibly needed on itd nodes
#unset "${!SLURM@}"




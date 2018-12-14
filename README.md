# balena-firedrake-install

This repository provides scripts to install and run Firedrake on Balena.

The master branch of this repository provides scripts for the master branch of Firedrake, the complex branch of this repository provides the same scripts for complex Firedrake.

To install firedrake, run (in an appropriate folder) `balena_firedrake_install_script.sh`.

NOTE: If you are installing firedrake in an interactive session (launched by running, e.g., `sinteractive -n 16`) then you *must* start another session on Balena and ssh in to the interative node you have been allocated. This is because, by default, interactive nodes have extra environment variables `SLURM_*` defined, which causes issues with MPI.

To run firedrake, first, activate your firedrake virtualenv, and then run `source balena_firedrake_setup_environment firedrake_path`, where `firedrake_path` is the path to the folder in which you installed firedrake.

Any tests involving parallel computations currently fail. This is almost certainly due to tests using recursive MPI calls, and OpenMPI having bugs with this. Running `pytest tests/regression -k 'not parallel'` should skip the parallel tests.
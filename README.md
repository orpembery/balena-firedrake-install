# balena-firedrake-install

This repository provides scripts to install and run Firedrake on Balena.

Currently, only the master branch of firedrake is supported.

To install firedrake, run (in an appropriate folder) `balena_firedrake_install_script.sh`.

To run firedrake, first, activate your firedrake virtualenv, and then run `source balena_firedrake_setup_environment firedrake_path`, where `firedrake_path` is the path to the folder in which you installed firedrake.

Any tests involving parallel computations currently fail. This is almost certainly due to tests using recursive MPI calls, and OpenMPI having bugs with this. Running `pytest tests/regression -k 'not parallel'` should skip the parallel tests.
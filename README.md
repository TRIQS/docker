# TRIQS Docker Image

This builds the [flatironinstitute/triqs](https://hub.docker.com/r/flatironinstitute/triqs) docker hub images which include triqs and applications.

It can be used to run a Jupyter notebook environment yourself or on [Binder](https://mybinder.org/v2/gh/TRIQS/docker/unstable), or to run a shell for development:

  docker run --rm flatironinstitute/triqs:unstable
  docker run --rm it flatironinstitute/triqs:unstable bash

A separate [docker build](compiler-explorer) provides the [compiler-explorer](https://github.com/mattgodbolt/compiler-explorer) with triqs enabled, running on port 10240.

## Dependencies

The submodules in this repository point to the latest revision of each module, and are updated automatically at the end of each successful Jenkins run (except for cpp2py which is updated manually).

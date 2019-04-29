# TRIQS Docker Image

This builds the [flatironinstitute/triqs](https://hub.docker.com/r/flatironinstitute/triqs) docker hub image which includes [triqs](https://triqs.github.io/triqs)
and the applications [cthyb](https://triqs.github.io/cthyb) and [dft_tools](https://triqs.github.io/dft_tools).

It can be used to run a Jupyter notebook environment yourself or on [Binder](https://mybinder.org/v2/gh/TRIQS/docker/master), or to run a shell for development:

```
docker run --rm -p 8888:8888 flatironinstitute/triqs
docker run --rm -ti flatironinstitute/triqs bash
```

The Jupyter notebook will be accessible at [http://localhost:8888](http://localhost:8888), where you should pass the token provided on the command line.
If you want the state of the virtual machine to be stored, drop `--rm` from the commands above.
A summary of useful docker commands can be found [here](https://www.docker.com/sites/default/files/Docker_CheatSheet_08.09.2016_0.pdf).

## Compiler Explorer

A separate [docker build](compiler-explorer) provides the [compiler-explorer](https://github.com/mattgodbolt/compiler-explorer) with triqs enabled, running on port 10240.

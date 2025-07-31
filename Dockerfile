FROM --platform=linux/amd64 ubuntu:24.04
LABEL org.opencontainers.image.source=https://github.com/triqs/triqs

RUN apt-get update && \
    apt-get install -y software-properties-common apt-transport-https curl && \
    curl -L https://users.flatironinstitute.org/~ccq/triqs3/noble/public.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/triqs.gpg && \
    add-apt-repository "deb https://users.flatironinstitute.org/~ccq/triqs3/noble/ /" -y && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      triqs \
      triqs_dft_tools \
      triqs_cthyb \
      triqs_ctseg \
      triqs_tprf \
      triqs_maxent \
      triqs_hubbardi \
      triqs_hartree_fock \
      triqs_nevanlinna \
      solid_dmft \
      \
      make \
      cmake \
      g++ \
      gfortran \
      git \
      htop \
      nano \
      vim \
      less \
      hdf5-tools \
      openssh-client \
      \
      libclang-dev \
      libboost-dev \
      libeigen3-dev \
      libfftw3-dev \
      libgmp-dev \
      libmpfr-dev \
      libhdf5-dev \
      libopenblas-dev \
      libopenmpi-dev \
      libnfft3-dev \
      openmpi-bin \
      openmpi-common \
      openmpi-doc \
      \
      python3-clang \
      python3-dev \
      python3-ipython \
      python3-mako \
      python3-matplotlib \
      python3-mpi4py \
      python3-numpy \
      python3-pandas \
      python3-pytest \
      python3-scipy \
      python3-setuptools \
      python3-skimage \
      python3-tk \
      python3-tomli \
      python3-venv \
      jupyter-notebook \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

ARG NB_USER=triqs
ARG NB_UID=1010
RUN useradd -u ${NB_UID} -m ${NB_USER} -o

USER ${NB_USER}
RUN python3 -m venv --system-site-packages /home/${NB_USER}/.venv
ENV VIRTUAL_ENV=/home/${NB_USER}/.venv \
    PATH=/home/${NB_USER}/.venv/bin:$PATH
RUN pip install jupyterlab jupyterhub jupyter-archive

#ARG BRANCH=3.3.x
#ARG NCORES=10
#ARG ARCH=native
#ENV SRC=/tmp/src BUILD=/tmp/build INSTALL=/usr \
#    CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu/openmpi:/#usr/include/hdf5/serial:$CPLUS_INCLUDE_PATH \
#    CC=gcc CXX=g++ CXXFLAGS="-march=${ARCH}"
#USER root
#RUN set -ex ; \
  #for pkg in ... ; do \
    #mkdir $BUILD ; cd $BUILD ; \
    #git clone https://github.com/TRIQS/$pkg --branch $BRANCH --depth 1 $SRC ; \
    #cmake $SRC -DCMAKE_INSTALL_PREFIX=$INSTALL ; \
    #make -j$NCORES ; \
    #make install ; \
    #rm -rf $SRC $BUILD ; \
  #done

USER ${NB_USER}
RUN git clone https://github.com/triqs/tutorials --branch 3.3.x --depth 1 /home/${NB_USER}/tutorials
WORKDIR /home/${NB_USER}/tutorials/

EXPOSE 8888
CMD ["jupyter","lab","--ip","0.0.0.0", "--no-browser"]

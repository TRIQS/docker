FROM --platform=linux/amd64 ubuntu:22.04

RUN apt-get update && \
    apt-get install -y software-properties-common apt-transport-https curl && \
    curl -L https://users.flatironinstitute.org/~ccq/triqs3/jammy/public.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/triqs.gpg && \
    add-apt-repository "deb https://users.flatironinstitute.org/~ccq/triqs3/jammy/ /" -y && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      triqs \
      triqs_dft_tools \
      triqs_cthyb \
      triqs_tprf \
      triqs_maxent \
      triqs_hubbardi \
      triqs_hartree_fock \
      solid_dmft \
      \
      make \
      cmake \
      g++-12 \
      gfortran \
      git \
      htop \
      nano \
      vim \
      less \
      hdf5-tools \
      libblas-dev \
      libboost-dev \
      libfftw3-dev \
      libgmp-dev \
      libmpfr-dev \
      libhdf5-dev \
      liblapack-dev \
      libopenmpi-dev \
      libnfft3-dev \
      \
      libclang-dev \
      python3-clang \
      python3-dev \
      python3-pandas \
      python3-pip \
      python3-pytest \
      python3-setuptools \
      python3-skimage \
      python3-tk \
      jupyter-notebook \
      \
      sudo \
      openssh-client \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

RUN pip3 install jupyterlab jupyter-archive
RUN ln -s /usr/bin/python3 /usr/bin/python
ENV CC=gcc-12 CXX=g++-12 \
    CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu/openmpi:/usr/include/hdf5/serial:$CPLUS_INCLUDE_PATH

ARG NB_USER=triqs
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
RUN useradd -u $NB_UID -m $NB_USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $NB_USER
WORKDIR /home/$NB_USER

ARG NCORES=10
ARG BRANCH=3.2.x
RUN set -ex ; \
  for pkg in Nevanlinna ; do \
    git clone https://github.com/TRIQS/$pkg --branch $BRANCH --depth 1 src ; \
    mkdir build ; cd build ; \
    cmake ../src -DCMAKE_INSTALL_PREFIX=$INSTALL ; \
    make -j$NCORES ; \
    sudo make install ; \
    cd .. ; \
    rm -rf src build ; \
  done

RUN git clone https://github.com/triqs/tutorials --branch 3.2.x --depth 1
WORKDIR /home/$NB_USER/tutorials/

EXPOSE 8888
CMD ["jupyter","lab","--ip","0.0.0.0"]

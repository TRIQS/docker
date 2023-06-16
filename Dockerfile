FROM ubuntu:jammy

RUN apt-get update && \
    apt-get install -y software-properties-common apt-transport-https curl && \
    curl -L https://users.flatironinstitute.org/~ccq/triqs3/jammy/public.gpg | apt-key add - && \
    add-apt-repository "deb https://users.flatironinstitute.org/~ccq/triqs3/jammy/ /" -y && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      triqs \
      triqs_dft_tools \
      triqs_cthyb \
      triqs_tprf \
      triqs_maxent \
      \
      clang \
      make \
      cmake \
      g++ \
      gfortran \
      git \
      hdf5-tools \
      libblas-dev \
      libboost-dev \
      libfftw3-dev \
      libgmp-dev \
      libhdf5-dev \
      liblapack-dev \
      libopenmpi-dev \
      libnfft3-dev \
      \
      libclang-dev \
      python3-clang \
      python3-dev \
      python3-pytest \
      python3-skimage \
      python3-pip \
      python3-setuptools \
      python3-tk \
      jupyter-notebook \
      \
      sudo \
      openssh-client \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

RUN pip3 install jupyterlab
ENV CXX=g++ \
    CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu/openmpi:/usr/include/hdf5/serial:$CPLUS_INCLUDE_PATH

ARG NB_USER=triqs
ARG NB_UID=1000
RUN useradd -u $NB_UID -m $NB_USER && \
    echo 'triqs ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $NB_USER
WORKDIR /home/$NB_USER

RUN set -ex ; \
  for pkg in hubbardI solid_dmft ; do \
    git clone https://github.com/TRIQS/$pkg --depth 1 src ; \
    mkdir build ; cd build ; \
    cmake ../src -DCMAKE_INSTALL_PREFIX=$INSTALL ; \
    make -j$NCORES ; \
    sudo make install ; \
    cd .. ; \
    rm -rf src build ; \
  done

RUN git clone https://github.com/triqs/tutorials --branch 3.1.x --depth 1
WORKDIR /home/$NB_USER/tutorials/

EXPOSE 8888
CMD ["jupyter","lab","--ip","0.0.0.0"]

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
      \
      libboost-dev \
      libeigen3-dev \
      libfftw3-dev \
      libgmp-dev \
      libmpfr-dev \
      libhdf5-dev \
      libopenblas-dev \
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
      python3-tomli \
      jupyter-notebook \
      \
      sudo \
      openssh-client \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python
ENV CC=gcc CXX=g++ \
    CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu/openmpi:/usr/include/hdf5/serial:$CPLUS_INCLUDE_PATH

ARG NB_USER=triqs
ARG NB_UID=983
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
RUN useradd -u $NB_UID -m $NB_USER && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $NB_USER
WORKDIR /home/$NB_USER

RUN pip3 install --user jupyterlab jupyter-archive --break-system-packages
ENV PATH=/home/$NB_USER/.local/bin:$PATH

#ARG NCORES=10
#ARG BRANCH=3.2.x
#RUN set -ex ; \
  #for pkg in ... ; do \
    #git clone https://github.com/TRIQS/$pkg --branch $BRANCH --depth 1 src ; \
    #mkdir build ; cd build ; \
    #cmake ../src -DCMAKE_INSTALL_PREFIX=$INSTALL ; \
    #make -j$NCORES ; \
    #sudo make install ; \
    #cd .. ; \
    #rm -rf src build ; \
  #done

RUN git clone https://github.com/triqs/tutorials --branch 3.3.x --depth 1
WORKDIR /home/$NB_USER/tutorials/

EXPOSE 8888
CMD ["jupyter","lab","--ip","0.0.0.0", "--no-browser"]

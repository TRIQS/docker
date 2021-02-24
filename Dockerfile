FROM ubuntu:focal

RUN apt-get update && \
    apt-get install -y software-properties-common apt-transport-https curl && \
    curl -L https://users.flatironinstitute.org/~ccq/triqs3/focal/public.gpg | apt-key add - && \
    add-apt-repository "deb https://users.flatironinstitute.org/~ccq/triqs3/focal/ /" -y && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      triqs \
      triqs_dft_tools \
      triqs_cthyb \
      triqs_tprf \
      triqs_maxent \
      \
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
      python3-dev \
      \
      clang \
      libclang-dev \
      python3-clang \
      \
      libnfft3-dev \
      \
      sudo \
      openssh-client \
      python3-pip \
      python3-setuptools \
      python3-tk \
      jupyter-notebook \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

ARG NB_USER=triqs
ARG NB_UID=1000
RUN useradd -u $NB_UID -m $NB_USER && \
    echo 'triqs ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $NB_USER
WORKDIR /home/$NB_USER
ENV CMAKE_PREFIX_PATH=/usr/lib/cmake/triqs \
    CPATH=/usr/include/openmpi:/usr/include/hdf5/serial:$CPATH
RUN curl -L https://api.github.com/repos/TRIQS/tutorials/tarball/unstable | tar xzf - --one-top-level=tutorials --strip-components=1
WORKDIR /home/$NB_USER/tutorials/TRIQSTutorialsPython

EXPOSE 8888
CMD ["jupyter","notebook","--ip","0.0.0.0"]

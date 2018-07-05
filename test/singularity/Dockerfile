FROM centos:latest

RUN yum -y update
RUN yum -y install \
      git \
      tar \
      vim \
      make \
      libtool \
      libarchive-devel \
      squashfs-tools \
      gcc-c++ \
      sudo \
      wget

WORKDIR /tmp
RUN wget https://github.com/singularityware/singularity/releases/download/2.5.2/singularity-2.5.2.tar.gz
RUN tar -xvf singularity-2.5.2.tar.gz
WORKDIR singularity-2.5.2
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local --sysconfdir=/etc
RUN make
RUN make install
WORKDIR /tmp
RUN rm -rf singularity-2.5.2

RUN wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.1.tar.gz
RUN tar -xvf openmpi-2.1.1.tar.gz
WORKDIR openmpi-2.1.1
RUN ./configure --prefix=/usr/local --enable-shared
RUN make
RUN make install
WORKDIR /tmp
RUN rm -rf openmpi-2.1.1.tar.gz openmpi-2.1.1

ARG NB_USER=triqs
ARG NB_UID=1000
RUN useradd -u $NB_UID -m $NB_USER && \
    echo 'triqs ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
COPY kanamori.py /home/$NB_USER/kanamori.py
WORKDIR /home/$NB_USER
USER $NB_USER

RUN singularity pull docker://flatironinstitute/triqs:unstable
CMD mpirun -np 2 singularity exec triqs-unstable.simg python kanamori.py

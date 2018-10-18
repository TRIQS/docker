FROM centos:latest

RUN yum -y update
RUN yum -y install \
      vim \
      git \
      tar \
      wget \
      make \
      gcc-c++ \
      sudo \
      openssl-devel \
      libuuid-devel \
      squashfs-tools \
      patch


# -- Install Go
WORKDIR /tmp
ENV VERSION=1.11.1 OS=linux ARCH=amd64
RUN wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz
RUN tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz

# -- Install openmpi-2.1.1
RUN wget https://download.open-mpi.org/release/open-mpi/v2.1/openmpi-2.1.1.tar.gz
RUN tar -xvf openmpi-2.1.1.tar.gz
WORKDIR openmpi-2.1.1
RUN ./configure --prefix=/usr/local --enable-shared
RUN make
RUN make install
WORKDIR /tmp
RUN rm -rf openmpi-2.1.1.tar.gz openmpi-2.1.1

# -- Add docker user
ARG NB_USER=docker
ARG NB_UID=1000
RUN useradd -u $NB_UID -m $NB_USER && \
    echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
COPY kanamori.py /home/$NB_USER/kanamori.py
USER $NB_USER

# -- Set up Singularity 3.0.0
ENV GOPATH=/home/$NB_USER/go
ENV PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin

RUN mkdir -p $GOPATH/src/github.com/sylabs
WORKDIR $GOPATH/src/github.com/sylabs
RUN git clone https://github.com/sylabs/singularity.git
WORKDIR singularity
RUN git checkout release-3.0

RUN go get -u -v github.com/golang/dep/cmd/dep

WORKDIR $GOPATH/src/github.com/sylabs/singularity
RUN ./mconfig
RUN make -C builddir
RUN sudo make -C builddir install

# -- Pull triqs image and run example script
WORKDIR /home/$NB_USER

RUN singularity pull docker://flatironinstitute/triqs
CMD mpirun -np 2 singularity exec triqs_latest.sif python kanamori.py

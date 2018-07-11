FROM flatironinstitute/triqs:unstable

USER root

# add gcc7, node8
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
ADD https://deb.nodesource.com/setup_8.x nodesetup.sh
RUN bash nodesetup.sh && rm nodesetup.sh
RUN apt-get install -y \
	g++-7 \
	nodejs

EXPOSE 10240
ADD https://api.github.com/repos/mattgodbolt/compiler-explorer/tarball/master /tmp/compiler-explorer.tar.gz
RUN chown triqs /tmp/compiler-explorer.tar.gz
USER triqs
RUN tar xzf /tmp/compiler-explorer.tar.gz --one-top-level --strip-components=1 && rm /tmp/compiler-explorer.tar.gz
WORKDIR compiler-explorer
RUN make dist
COPY c++.local.properties etc/config
CMD ["make", "run"]

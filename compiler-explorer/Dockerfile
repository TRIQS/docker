FROM flatironinstitute/triqs:latest

USER root

# Setup Compiler Explorer with various gcc and clang versions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN sudo apt-get update && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends \
	nodejs \
	g++-6 \
	g++-7 \
	g++-8 \
	clang-6.0 \
	clang-7 && \
    sudo apt-get autoremove --purge -y && \
    sudo apt-get autoclean -y && \
    sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/*

EXPOSE 10240
ADD https://api.github.com/repos/mattgodbolt/compiler-explorer/tarball/master /tmp/compiler-explorer.tar.gz
RUN tar xzf /tmp/compiler-explorer.tar.gz --one-top-level --strip-components=1 && rm /tmp/compiler-explorer.tar.gz
COPY c++.local.properties compiler-explorer/etc/config
RUN chown -R triqs compiler-explorer
USER triqs
WORKDIR compiler-explorer
RUN make dist
CMD make EXTRA_ARGS='--language c++'

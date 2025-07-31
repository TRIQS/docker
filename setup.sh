#!/bin/bash

if [[ ! -d ~/home/tutorials ]]
then
  git clone https://github.com/harrisonlabollita/TRIQS-tutorials --branch 3.3.x --depth 1 ~/home/tutorials & sleep 5
fi
cd ~/home/tutorials
export SHELL=/bin/bash

exec "$@"

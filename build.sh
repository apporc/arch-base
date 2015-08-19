#!/bin/bash

# build: Bootstrap a base Arch Linux system container.

set -e -u -o pipefail

SCRIPT=$(readlink -f "$0")
PWD=$(dirname $SCRIPT)

# build bootstrap archive
${PWD}/bootstraps/scripts/build.sh
# build docker container
cd ${PWD}
docker build -t apporc/arch-bootstrap .

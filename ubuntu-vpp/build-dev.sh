#!/bin/bash

SRC_ROOT=$(dirname $(realpath $0))
source ${SRC_ROOT}/dev.env

# DOCKER_IMAGE="vpp-dev-env"
echo "Building docker container ${DOCKER_IMAGE} for building VPP"

docker build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  --build-arg USER_NAME=${USER} \
  -t ${VPPDEV_IMAGE} \
  -f ${VPP_DOCKER_DIR}/Dockerfile.dev \
  ${VPP_DOCKER_DIR}
if [ $? -ne 0 ]; then
    echo "Container ${VPPDEV_IMAGE} build failed"
else
    echo "Container ${VPPDEV_IMAGE} build succeeded"
fi
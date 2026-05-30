#!/usr/bin/bash

DOCKER_IMAGE="vpp-builder:phase0"
echo "Building docker container ${DOCKER_IMAGE} for building VPP"

docker build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  --build-arg USER_NAME=$USER \
  -t ${DOCKER_IMAGE} \
  -f Dockerfile.builder .
if [ $? -ne 0 ]; then
    echo "Container ${DOCKER_IMAGE} build failed"
else
    echo "Container ${DOCKER_IMAGE} build succeeded"
fi

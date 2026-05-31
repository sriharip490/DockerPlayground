#!/usr/bin/bash

set -x

VPPDEV_CNR="vpp-dev-container"
VPPDEV_IMAGE="vpp-dev-env"

MNT_DIR_SRC="${HOME}/workspace/project"
MNT_DIR_TGT="/workspace"

echo "Starting VPP dev container ${VPPDEV_CNR}"

docker run -it \
  --privileged \
  --name ${VPPDEV_CNR} \
  --rm \
  -v /dev:/dev \
  -v ${MNT_DIR_SRC}:${MNT_DIR_TGT} \
  ${VPPDEV_IMAGE}

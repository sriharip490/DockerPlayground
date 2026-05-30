#!/usr/bin/bash

set -x

VPPDEV_CNR="vpp-builder"
VPPDEV_IMAGE="vpp-builder:phase0"

MNT_DIR_SRC="${HOME}/workspace/project"
MNT_DIR_TGT="/workspace"

echo "Starting VPP dev container ${VPPDEV_CNR}"

docker run -it \
  --name ${VPPDEV_CNR} \
  --rm \
  -v ${MNT_DIR_SRC}:${MNT_DIR_TGT} \
  ${VPPDEV_IMAGE}

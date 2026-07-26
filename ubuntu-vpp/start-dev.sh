#!/bin/bash

#set -x

SRC_ROOT=$(dirname $(realpath $0))
source ${SRC_ROOT}/dev.env

# VPPDEV_CNR="vpp-dev-container"
# VPPDEV_IMAGE="vpp-dev-env"

MNT_DIR_SRC=${VPP_ROOT_DIR}
# MNT_DIR_TGT="/workspace"

echo "VPP Docker image: ${VPPDEV_IMAGE}"
echo "Mounting ${MNT_DIR_SRC} to ${MNT_DIR_TGT}"
echo "Starting VPP dev container ${VPPDEV_CNR}"

docker run -it \
  --privileged \
  --name ${VPPDEV_CNR} \
  --rm \
  -v /dev:/dev \
  -v ${MNT_DIR_SRC}:${MNT_DIR_TGT} \
  ${VPPDEV_IMAGE}

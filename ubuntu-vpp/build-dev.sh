#!/usr/bin/bash

echo "Building docker development environment"
docker build \
  -t vpp-dev-env \
  -f ${HOME}/workspace/DockerPlayground/ubuntu-vpp/Dockerfile.dev \
  ${HOME}/workspace/project/vpp-dev

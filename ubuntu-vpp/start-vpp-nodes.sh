#!/usr/bin/bash

export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
export HOST_USER=${USER}

node1="vpp-dev-1"
node2="vpp-dev-2"

echo "Starting two VPP nodes - ${node1}, ${node2}"

docker compose up -d --remove-orphans


#!/bin/bash

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export USER_NAME=${USER}

node1="vpp-dev-1"
node2="vpp-dev-2"

echo "Starting two VPP nodes - ${node1}, ${node2}"

docker compose --env-file dev.env up -d --remove-orphans --build

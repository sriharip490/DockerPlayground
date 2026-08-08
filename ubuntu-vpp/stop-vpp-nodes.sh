#!/bin/bash

node1="vpp-dev-1"
node2="vpp-dev-2"

echo "Stopping VPP nodes ${node1}, ${node2}"

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export USER_NAME=${USER}

docker compose --env-file dev.env down



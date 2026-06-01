#!/usr/bin/bash

node1="vpp-dev-1"
node2="vpp-dev-2"

echo "Stopping VPP nodes ${node1}, ${node2}"

#docker stop vpp-dev-1 vpp-dev-2

docker compose down



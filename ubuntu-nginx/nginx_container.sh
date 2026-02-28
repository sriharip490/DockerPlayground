#!/bin/bash

cnr="ubuntu-nginx"
cnr_name="ubuntu-nginx-container"
cnr_net="tensor-net"

echo "Starting nginx container [${cnr}] ..."

docker run -itd \
    --rm --name ${cnr_name} \
    -p 8080:80 \
    -v $(pwd)/html:/var/www/html \
    --network ${cnr_net} ${cnr}

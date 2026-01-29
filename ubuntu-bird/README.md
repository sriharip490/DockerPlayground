# Docker Containers - Bird BGP

This is the BGP playground. Spin up 3 containers running Bird daemon with BGP
configuration. Topology has 3 containers R1, R2, R3

        (AS 65001)           (AS 65002)           (AS 65003)

          R1 ----------------- R2 ----------------- R3
        10.10.0.2/24       10.10.0.3/24        10.10.23.3/24
                           10.10.23.2/24

## Components

These are the components that must be in place to run the Bird-BGP containers
* Create 2 docker subnets *birdnet* (10.10.0.0/24) and *birdnet23*  
  (10.10.23.0/24)
  ```
  docker network create --subnet 10.10.0.0/24 birdnet

  docker network create --subnet 10.10.23.0/24 birdnet23
  ```
* The bird configuration files - one per container r[1-3]-bird.conf which
  is bind mounted as a volume inside the container.

## How to build the image
```
docker build -t bird-ubuntu .
```

## Start the containers

Start the containers - execute the following commands
```
- start container bird-r1

docker run -itd --rm --name bird-r1 \
  --network birdnet --ip 10.10.0.2 \
  --cap-add NET_ADMIN --cap-add NET_RAW \
  -v $(pwd)/r1-bird.conf:/etc/bird/bird.conf \
  bird-ubuntu

- start container bird-r2

docker run -itd --rm --name bird-r2 \
  --network birdnet --ip 10.10.0.3 \
  --cap-add NET_ADMIN --cap-add NET_RAW \
  -v $(pwd)/r2-bird.conf:/etc/bird/bird.conf \
  bird-ubuntu

- connect the container bird-r2 to network birdnet23

docker network connect --ip 10.10.23.2 birdnet23 bird-r2

- start container bird-r3

docker run -itd --rm --name bird-r3 \
  --network birdnet23 --ip 10.10.23.3 \
  --cap-add NET_ADMIN --cap-add NET_RAW \
  -v $(pwd)/r3-bird.conf:/etc/bird/bird.conf \
  bird-ubuntu

- Check the status of the 3 containers

docker ps
```

## Happy playing

Now login to the containers and play 
```
- login into the container R1, similar command for R2, R3
  docker exec -it bird-r1 /bin/bash

- use birdc command to display various configurations. 

  Example 1 - show route

root@5eaa3049e756:/# birdc show route
BIRD 2.0.8 ready.
Table master4:
4.4.4.4/32           unicast [r2 04:24:24.098] * (100) [AS65003i]
	via 10.10.0.3 on eth0
3.3.3.3/32           unicast [r2 04:23:54.072] * (100) [AS65002i]
	via 10.10.0.3 on eth0
10.10.0.0/24         unicast [direct1 04:23:27.747] * (240)
	dev eth0
                     unicast [r2 04:23:54.072] (100) [AS65002i]
	via 10.10.0.3 on eth0
2.2.2.2/32           unicast [static1 04:23:27.735] * (200)
	dev lo
10.10.23.0/24        unicast [r2 04:23:54.107] * (100) [AS65002i]
	via 10.10.0.3 on eth0

  Example 2 - show protocols

root@5eaa3049e756:/# birdc show protocols
BIRD 2.0.8 ready.
Name       Proto      Table      State  Since         Info
static1    Static     master4    up     04:23:27.735  
device1    Device     ---        up     04:23:27.735  
direct1    Direct     ---        up     04:23:27.735  
kernel1    Kernel     master4    up     04:23:27.735  
r2         BGP        ---        up     04:23:51.392  Established   
root@5eaa3049e756:/# 
```

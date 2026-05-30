# VPP Builder

* Docker file used `Dockerfile.builder`
* This docker container sets up environment for building VPP
* Container based on Ubuntu 22.04

## Container Setup
* Install minimal debian packages needed to build VPP
  - `make install-dep` installs all the tools needed to build VPP
  - `make build` does the actual build
* User name, user_id and group_id are passed to the docker container
  startup. This ensures that the container has the same user login 
  credentials as the host user login.
* Container is created with /workspace folder where the folder with
  VPP git clone is to be mounted (refer start.sh)

## Container build
* Build the container using the build.sh

## Container start
* Start the container using start.sh
* Few points to be noted
  - Create folder for VPP sources and build 
  - Clone the git vpp repository
  - In start.sh, modify the MNT_DIR_SRC macro with the folder name
* After container starts
  - sudo make install-dep
  - make build


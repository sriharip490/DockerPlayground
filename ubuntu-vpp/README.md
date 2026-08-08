# VPP Playground
Welcome to VPP playground !

## Quick Summary
This README covers 
* How to setup your workspace to build, deploy Docker container images for building and testing VPP
* The pre-requisites, specific instructions needed for build etc.
* VPP build depends on certain tools. This folder contains 2 Dockerfiles 
  - Dockerfile.builder - covered in section `VPP Builder`
  - Dockerfile.dev - covered in section `VPP Dev Builder`
  Recommened that go through both sections, and for convenience, follow `VPP Dev Builder`
* How to bring up 2 VPP nodes together using docker compose, for multi-node testing

## Repository Contents
* `Dockerfile.builder` - image for `VPP Builder` workflow, dependencies installed manually
* `Dockerfile.dev` - image for `VPP Dev Builder` workflow, dependencies baked in at image build time
* `build.sh` - builds the `VPP Builder` image
* `start.sh` - starts the `VPP Builder` container
* `build-dev.sh` - builds the `VPP Dev Builder` image
* `start-dev.sh` - starts the `VPP Dev Builder` container (single node)
* `docker-compose.yml` - brings up 2 `VPP Dev Builder` containers, networked together
* `start-vpp-nodes.sh` - wrapper around `docker compose up`, starts the 2 node setup
* `stop-vpp-nodes.sh` - wrapper around `docker compose down`, stops the 2 node setup
* `dev.env` - single place for all paths, image and container names used by the dev scripts and compose file

## VPP Builder vs VPP Dev Builder
Both workflows get you a container that can build VPP. The only real difference is when `make install-dep` runs.

| | VPP Builder | VPP Dev Builder |
|---|---|---|
| Dockerfile | `Dockerfile.builder` | `Dockerfile.dev` |
| `make install-dep` | run manually, every time you start the container | baked into the image at build time |
| Steps inside container | `sudo make install-dep` then `make build` | just `make build` |
| Build script | `build.sh` | `build-dev.sh` |
| Start script | `start.sh` | `start-dev.sh` |
| Multi-node support | no | yes, via `docker-compose.yml` |
| Recommended | - | yes |

## Pre-Requisites
* Docker installed on the host
* Clone [github VPP]() repository on the host - this is mounted into the container, not baked into the image
* Need to git tag the source since `vpp-dev/src/CMakeLists.txt` runs
  `git describe` to fix the `VPP_LIB_VERSION` below snippet
```
string(REPLACE "-" ";" VPP_LIB_VERSION ${VPP_VERSION})
list(GET VPP_LIB_VERSION 0 VPP_LIB_VERSION)

## Run the following command inside your VPP source folder, on the host
git tag -a v0.0.0 -m "version 0.0.0"
```
* For `VPP Dev Builder` / multi-node, edit `dev.env` and point it at your paths - see `dev.env Reference` below

## VPP Builder

* Docker file used `Dockerfile.builder`
* This docker container sets up environment for building VPP
* Container based on Ubuntu 22.04

### Container Setup
* Install minimal debian packages needed to build VPP
  - `make install-dep` installs all the tools needed to build VPP
  - `make build` does the actual build
* `user_name, user_id and group_id` are passed to the docker container
  startup. This ensures that the container has the same user login 
  credentials as the host user login.
* Container is created with `/workspace` folder where the folder with
  VPP git clone is to be mounted (refer `start.sh`)

### Container build
* Build the container using the `build.sh`

### Container start
* Start the container using start.sh
* Few points to be noted
  - Create folder for VPP sources and build 
  - Clone the git vpp repository
  - In `start.sh`, modify the `MNT_DIR_SRC` macro with the folder name
* After container starts

### Build steps
```
  sudo make install-dep
  make build
```
### Build Clean
* For cleaning the build, run the command from inside the container in the workspace vpp root folder
```
make wipe
```

## VPP Dev Builder
This is a better version of builder Docker container. The VPP build 
dependencies are taken care during image build time. 

`make install-dep` step is performed during docker image build.

* Note - `Dockerfile.dev` also does a `git clone` of VPP inside the image, but only to run `install-dep` at build time.
  At container start, `start-dev.sh` / `docker-compose.yml` mount your host's `VPP_SRC_DIR` (from `dev.env`) over
  `/workspace/vpp`, so the source you actually build is the one on your host, not the one baked into the image.
  Make sure your host checkout is git-tagged per `Build pre-steps` above.

### Container build
* Build the image using `build-dev.sh` - reads image/paths from `dev.env`

### Container start
* Start the container using `start-dev.sh`
* Mounts `VPP_ROOT_DIR` (from `dev.env`) into the container at `/workspace`

### Build steps
```
# For building VPP
make build

# For clean VPP
make wipe
```

### Test Run
Minimal VPP execution run
```
export MAKE_PARALLEL_JOBS=2
make run
WARNING: STARTUP_CONF not defined or file doesn't exist.
         Running with minimal startup config:  unix { interactive cli-listen /run/vpp/cli.sock gid 1000 } dpdk { no-pci } \n
clib_sysfs_prealloc_hugepages:226: pre-allocating 20 additional 2048K hugepages on numa node 0
buffer                [warn  ]: numa[0] falling back to non-hugepage backed buffer pool (vlib_physmem_shared_map_create: pmalloc_map_pages: failed to mmap 20 pages at 0x1000000000 fd 5 numa 0 flags 0x11: Cannot allocate memory)
perfmon               [warn  ]: skipping source 'intel-uncore' - intel_uncore_init: no uncore units found
vat-plug/load         [error ]: vat_plugin_register: idpf plugin not loaded...
vat-plug/load         [error ]: vat_plugin_register: oddbuf plugin not loaded...
    _______    _        _   _____  ___ 
 __/ __/ _ \  (_)__    | | / / _ \/ _ \
 _/ _// // / / _ \   | |/ / ___/ ___/
 /_/ /____(_)_/\___/   |___/_/  /_/    

DBGvpp# 
DBGvpp# 
DBGvpp# 
DBGvpp# 
```

## Multiple VPP nodes
* Use of docker compose yml definition for starting 2 or more VPP container nodes.
  `start-vpp-nodes.sh` is used.
* Both nodes use the `VPP Dev Builder` image (`Dockerfile.dev`), built automatically by `docker compose` if needed
* Networking, as defined in `docker-compose.yml`
  - `vpp-node-1` - attached to `vpp-net-1` (private) and `vpp-transit` (shared)
  - `vpp-node-2` - attached to `vpp-transit` (shared) only
  - both share `dev.env` for image name, container names and host UID/GID
* Start the nodes
```
./start-vpp-nodes.sh
```
* After launch of the two nodes, `vpp service` needs to be started in each
* vpp uses startup configuration - run the following command
```
# Run Node 1 configuration
./build-root/install-vpp_debug-native/vpp/bin/vpp \
  unix { interactive runtime-dir /tmp/vpp1 cli-listen /tmp/cli-1.sock } \
  buffers { buffers-per-numa 4000 default data-size 2048 } \
  dpdk { no-pci }

# Run Node 2 configuration
./build-root/install-vpp_debug-native/vpp/bin/vpp \
  unix { interactive runtime-dir /tmp/vpp2 cli-listen /tmp/cli-2.sock } \
  buffers { buffers-per-numa 4000 default data-size 2048 } \
  dpdk { no-pci }
```
* Stoping the 2 nodes, we use `stop-vpp-nodes.sh`

## dev.env Reference
* `WS_ROOT` - root of your workspace on the host
* `VPP_ROOT_DIR` - folder containing your VPP checkout
* `VPP_SRC_DIR` - the actual VPP git clone, mounted to `/workspace/vpp` in the containers
* `VPP_DOCKER_DIR` - path to this folder (docker build context)
* `MNT_DIR_TGT` - mount target inside the container, `/workspace`
* `VPPDEV_IMAGE` - image name used by `build-dev.sh`, `start-dev.sh` and `docker-compose.yml`
* `VPPDEV_CNR`, `VPPDEV_CNR_1`, `VPPDEV_CNR_2` - container names, single node and 2-node setup
* `VPPDEV_NET_1`, `VPPDEV_NET_2`, `VPPDEV_TRANSIT_NET` - docker network names
* `VPPDEV_CNR_1_IP`, `VPPDEV_CNR_1_TRANSIT_IP`, `VPPDEV_CNR_2_TRANSIT_IP` - static IPs assigned to the nodes
* `VPPDEV_NET_1_SUBNET`, `VPPDEV_TRANSIT_NET_SUBNET` - subnets for the above networks
* Edit the paths (`WS_ROOT`, `VPP_ROOT_DIR`) to match your host before running any of the dev / multi-node scripts

## Troubleshooting
* `git describe` / `VPP_LIB_VERSION` build failure - source isn't tagged, see `Build pre-steps` above
* Hugepage warnings on `make run` - expected on hosts without hugepages configured, safe to ignore for basic testing
* Wrong VPP source showing up inside a `VPP Dev Builder` container - check `VPP_SRC_DIR` in `dev.env`, it overrides
  whatever was cloned into the image at build time

## Quick Reference
```
# VPP Builder - single container, manual install-dep
./build.sh
./start.sh
sudo make install-dep && make build

# VPP Dev Builder - single container, install-dep baked in
./build-dev.sh
./start-dev.sh
make build

# Multi-node - 2 containers via docker compose
./start-vpp-nodes.sh
./stop-vpp-nodes.sh
```

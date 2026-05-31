# VPP Playground
Welcome to VPP playground !

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

### Build pre-steps
* Need to git tag the source since the `vpp-dev/src/CMakeLists.txt` runs
  `git describe` to fix the `VPP_LIB_VERSION` below snippet
```
string(REPLACE "-" ";" VPP_LIB_VERSION ${VPP_VERSION})
list(GET VPP_LIB_VERSION 0 VPP_LIB_VERSION)

## Run the following command inside /workspace/vpp-dev
git tag -a v0.0.0 -m "version 0.0.0"
```

### Build steps
```
  sudo make install-dep
  make build
```

## VPP Dev Builder
This is a better version of builder Docker container. The VPP build 
dependencies are taken care during image build time. 

`make install-dep` step is performed during docker image build.

### Build steps
```
make build
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
 _/ _// // / / / _ \   | |/ / ___/ ___/
 /_/ /____(_)_/\___/   |___/_/  /_/    

DBGvpp# 
DBGvpp# 
DBGvpp# 
DBGvpp# 
``


# Container with Tensorflow

* Work in Progress 
* Major issue being getting the Tensorflow version which is built without
  `avx` support
* No available tensorflow wheel which may help the cause
* Alternative is to do a bazel build using Tensorflow sources
* This is the link
    https://www.tensorflow.org/install/source

## Requirements
* Container must have
  - Python installation - version supporting Tensorflow
  - Support for Tensorflow without AVX (some information below)
  - Storage limited to 2GiB
  - Network 

## AVX - Advanced Vector Extensions
* AVX/AVX2 are CPU instructions which help in speed up complex math
  (matrix, linear algebra) needed in Machine Learning. 
* Essentially SIMD use case - same operation on number of vectors in
  a single instruction
* Check if CPU supports AVX
  $ cat /proc/cpuinfo | grep -i avx

## Docker File
* Whatever needed for final docker container
  - Python 3.12
  - Tensorflow 2.19
  - Jupyterlab
  - scikit-learn and other ML libraries
  - Other dependencies

### Additional files
* `.dockerignore` - helps in reduction of container size by filtering
  out the files from getting copied into the container.

### Docker Network
* Create a `bridge network` for use by the tensorflow container with
  subnet 10.10.48.0/24, gateway 10.10.48.1
```
  docker network create \
        --driver bridge \
        --subnet 10.10.48.0/24 \
        --gateway 10.10.48.1 tensor-net
```
* This step may be part of the Docker compose (below)

### Docker storage
* Create a 2 Gb file using `truncate` command
  truncate -s 5G tf-storage.img
* Create ext4 FS and loop mount the file 
* The loop mount device is used to store data, code etc.
* Container uses the loop mount device as a `volume`

### Docker image build
* Run the command to build the image
```
  docker build -t tf-no-avx .
```

### Docker contaimer run - `Manual run`

docker run -it --name tf-container --network tensor-ne -v /mnt/tf/:/app tf-no-avx

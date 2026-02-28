# Docker Container for nginx
How to setup docker container for nginx webserver

## Remove Docker Image
If the `ubuntu-nginx` docker image exists and there is a need to rebuild the image
```
docker rmi ubuntu-nginx:latest
```

## Build Docker Image
To build docker image
```
docker build -t ubuntu-nginx .
docker images
```

## Check the docker images 
```
docker images
```

## Run the Docker Container
The docker container is 
* Attached to an existing docker network `tensor-network`
* Mount volume containing the html files and related resources
```
docker run -itd \
    --rm --name ubuntu-nginx-container \
    -p 8080:80 \
    -v $(pwd)/html:/var/www/html \
    --network tensor-net ubuntu-nginx
```

## Container Inspection
Login to the container for inspection, debugging etc
```
docker exec -it ubuntu-nginx-container /bin/bash
```

## HTTPS support - secure nginx 

### Self-signed certificate
Generate self signed certificate to be used by nginx via `nginx.conf`
```
openssl req -x509 -nodes -days 365 -newkey \
    rsa:2048 -keyout nginx.key -out nginx.crt
```








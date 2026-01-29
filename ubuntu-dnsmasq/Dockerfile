
# Installs dnsmasq
FROM ubuntu:22.04

# Add the metadata for the image
LABEL maintainer="PSH Linux <srihari.linux5@example.com>"
LABEL version="1.0"
LABEL description="Minimal container which has DNSMASQ"

# Build time environment variables
ARG CONFIG_DIR=$HOME/docker/config

# DNS server ports which the container will be reachable
EXPOSE 53/udp
EXPOSE 53/tcp

# copy init files
COPY .vimrc /root/

# Build the image
RUN apt-get update && \
	apt-get install -y --no-install-recommends dnsmasq \
	vim \
	net-tools \
	iputils-ping \
	dnsutils \
	iproute2 \
	tcpdump && \
	rm -rf /var/lib/apt/lists/*

# preserve the default and override with defined file
RUN cp /etc/dnsmasq.conf /etc/dnsmasq.conf.default
COPY dnsmasq.conf /etc/dnsmasq.conf

# Command to run in the container
ENTRYPOINT ["/bin/bash"]


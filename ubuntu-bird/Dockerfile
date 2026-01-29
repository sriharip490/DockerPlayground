# Start from Ubuntu 22.04 (Jammy)
FROM ubuntu:22.04

# Add the metadata for the image
LABEL maintainer="PSH Linux <srihari.linux5@example.com>"
LABEL version="1.0"
LABEL description="Minimal container which has BIRD daemon"

# Install BIRD and basic networking tools, and lest you forget vim
RUN apt-get update && \
    apt-get install -y bird2 \
                     net-tools \
                     iproute2  \
                     iputils-ping \ 
                     tcpdump \
                     vim && \
    mkdir /run/bird && \
    rm -rf /var/lib/apt/lists/*

# Copy a sample config (you can override with a bind mount)
COPY bird.conf /etc/bird/bird.conf

# Copy the entrypoint script into the container
COPY bird_start.sh /usr/local/bin/bird_start.sh

# Make the script executable
RUN chmod +x /usr/local/bin/bird_start.sh

# Expose BGP port
EXPOSE 179/tcp

# Make /etc/bird writable for runtime changes
VOLUME ["/etc/bird"]

# Command to run in the container
ENTRYPOINT ["/usr/local/bin/bird_start.sh"]

# Default interactive shell via CMD
CMD ["/bin/bash"]



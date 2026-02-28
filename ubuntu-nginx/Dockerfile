# Use Ubuntu 22.04 as base
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install nginx
RUN apt-get update && \
    apt-get install -y nginx \
                       net-tools \
                       iputils-ping \
                       tcpdump \
                       vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose port 80
EXPOSE 80

COPY nginx_start.sh /usr/local/bin/nginx_start.sh

# Command to run in the nginx container
ENTRYPOINT ["/usr/local/bin/nginx_start.sh"]

# Start nginx in foreground
CMD ["/bin/bash"]

#CMD ["nginx", "-g", "daemon off;"]


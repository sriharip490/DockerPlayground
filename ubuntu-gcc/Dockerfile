
# Installs build-essentials
FROM ubuntu:22.04

# Add metadata for the image
LABEL maintainer="PSH Linux <srihari.linux5@example.com>"
LABEL version="1.0"
LABEL description="Minimal container which has gcc compiler"

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential && \
	apt-get install -y --no-install-recommends vim && \
	rm -rf /var/lib/apt/lists/*

# copy init files
COPY .vimrc ~/

# copy the setup script from host to the container
COPY setup.sh /app/data/

# execute permissions
RUN chmod +x /app/data/setup.sh

# set up working directory
WORKDIR /app/data

# command to run in the container
ENTRYPOINT ["/app/data/setup.sh"]

# default argument to the entrypoint
CMD ["-c build"]


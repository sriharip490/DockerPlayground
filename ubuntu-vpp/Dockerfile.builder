# Container for building VPP

FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install core packages needed to clone VPP and bootstrap dependencies
RUN apt-get update && apt-get install -y \
    git \
    sudo \
    curl \
    make \
    python3 \
    lsb-release \
    net-tools \
    iputils-ping \
    tcpdump \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Build arguments to dynamically pass host user/group IDs
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=developer

# Create a group and user matching the host configuration
RUN groupadd -g ${GROUP_ID} ${USER_NAME} && \
    useradd -m -u ${USER_ID} -g ${USER_NAME} -s /bin/bash ${USER_NAME}

# Grant passwordless sudo privilege to this user
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the operational context to the new user
USER ${USER_NAME}

# VPP scripts require sudo-enabled user or root context.
# Working directory to /workspace where you will do your work.
WORKDIR /workspace

CMD ["/bin/bash"]

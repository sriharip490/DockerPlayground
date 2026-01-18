FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    ca-certificates \
    build-essential \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.9 \
    python3.9-distutils \
    python3.9-venv \
    && rm -rf /var/lib/apt/lists/*

# Install pip for Python 3.9
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

# Set Python 3.9 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1

# Upgrade pip
RUN pip install --upgrade pip

# Install TensorFlow 2.10 (last version without AVX requirement)
RUN pip install tensorflow==2.10.1

CMD ["/bin/bash"]


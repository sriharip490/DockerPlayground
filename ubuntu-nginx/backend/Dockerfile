FROM node:20

# Install useful utilities
RUN apt-get update && apt-get install -y \
    vim \
    net-tools \
    iputils-ping \
    curl \
    procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./

RUN npm install express jsonwebtoken bcryptjs cookie-parser

COPY . .

CMD ["node", "server.js"]


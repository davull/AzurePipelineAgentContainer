FROM ubuntu:24.04

ARG NODE_VERSION=22
ARG DEBIAN_FRONTEND=noninteractive

# Invalidate cache
RUN ls -la

# Update packages
RUN apt-get update && apt-get upgrade -y --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https apt-utils default-jre graphviz gpg-agent \
    libicu-dev sudo build-essential gcc make software-properties-common \
    unzip wget zip locales mysql-client iputils-ping telnet \
 && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen "en_US.UTF-8" \
 && update-locale LC_ALL="en_US.UTF-8"

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install cypress dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgtk2.0-0t64 libgtk-3-0t64 libgbm-dev libnotify-dev \
    libnss3 libxss1 libasound2t64 libxtst6 xauth xvfb \
 && rm -rf /var/lib/apt/lists/*

# Install git
RUN add-apt-repository ppa:git-core/ppa -y && \
    apt-get update && \
    apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN mkdir -p /etc/apt/keyrings && \
    wget -q -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_VERSION}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs

# Install Playwright dependencies
RUN npx --yes playwright install-deps

# Install azure cli
RUN wget https://aka.ms/InstallAzureCLIDeb -O InstallAzureCLIDeb.sh && \
    bash InstallAzureCLIDeb.sh && \
    rm InstallAzureCLIDeb.sh && \
    apt-get update && \
    apt-get install -y azure-cli \
 && rm -rf /var/lib/apt/lists/*

# Install docker compose
RUN wget -q "https://github.com/docker/compose/releases/download/v2.29.7/docker-compose-$(uname -s)-$(uname -m)" -O /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
        
CMD ["/bin/bash"]

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https default-jre graphviz libicu-dev \
    sudo software-properties-common unzip wget \
 && rm -rf /var/lib/apt/lists/*

# Install latest git
RUN add-apt-repository ppa:git-core/ppa -y && \
    apt-get update && \
    apt-get install -y git

# Install Node.js 18.x
RUN wget https://deb.nodesource.com/setup_18.x -O nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get update && \
    apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/*

# Install Powershell
RUN wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell \
 && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]

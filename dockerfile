FROM ubuntu:22.04

ARG NODE_VERSION=18
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https apt-utils default-jre graphviz gpg-agent \
    libicu-dev sudo build-essential gcc make software-properties-common \
    unzip wget zip \
 && rm -rf /var/lib/apt/lists/*

# Install cypress dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 \
    libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
 && rm -rf /var/lib/apt/lists/*

# Install latest git
RUN add-apt-repository ppa:git-core/ppa -y && \
    apt-get update && \
    apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN wget https://deb.nodesource.com/setup_${NODE_VERSION}.x -O nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    rm nodesource_setup.sh && \
    apt-get update && \
    apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/*

# Install Playwright dependencies
RUN npx --yes playwright install-deps

# Install Powershell
RUN wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell \
 && rm -rf /var/lib/apt/lists/*

# Install azure cli
RUN wget https://aka.ms/InstallAzureCLIDeb -O InstallAzureCLIDeb.sh && \
    bash InstallAzureCLIDeb.sh && \
    rm InstallAzureCLIDeb.sh && \
    apt-get update && \
    apt-get install -y azure-cli \
 && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]

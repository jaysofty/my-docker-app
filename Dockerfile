FROM jenkins/jenkins:lts

USER root

# Install dependencies + Docker CLI (clean and minimal)
RUN apt-get update && apt-get install -y \
    lsb-release \
    python3-pip \
    curl \
    ca-certificates \
    gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg \
       | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo \
       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
       https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER jenkins

# Install plugins (avoid strict pinning unless necessary)
# RUN jenkins-plugin-cli --plugins \
#     blueocean \
#     docker-workflow
FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y \
    lsb-release \
    python3 \
    python3-pip \
    curl \
    ca-certificates \
    gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg \
       | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo \
       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
       https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Give Jenkins permission to use Docker
RUN groupadd -f docker && usermod -aG docker jenkins

# Install system tools (like tidy)
RUN apt-get update && \
    apt-get install -y tidy && \
    apt-get clean

    # Install Trivy
RUN apt-get update && apt-get install -y wget gnupg lsb-release && \
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add - && \
    echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" > /etc/apt/sources.list.d/trivy.list && \
    apt-get update && \
    apt-get install -y trivy && \
    apt-get clean

# Install essential plugins
RUN jenkins-plugin-cli --plugins \
    git \
    docker-workflow \
    workflow-aggregator \
    blueocean

# Switch back to Jenkins user
USER jenkins
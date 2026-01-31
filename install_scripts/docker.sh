#!/usr/bin/env bash
set -euo pipefail

echo "<--- installing docker... --->"

# Check if Docker is already installed
if command -v docker >/dev/null 2>&1; then
    echo "Docker is already installed ($(docker --version))"
    echo "Skipping installation."
    exit 0
fi

# Detect the distribution
if [[ ! -f /etc/os-release ]]; then
    echo "ERROR: Cannot detect distribution (missing /etc/os-release)"
    exit 1
fi

source /etc/os-release

# Supported distributions: ubuntu, debian
DISTRO_LOWER=$(echo "$ID" | tr '[:upper:]' '[:lower:]')
if [[ "$DISTRO_LOWER" != "ubuntu" && "$DISTRO_LOWER" != "debian" ]]; then
    echo "ERROR: Unsupported distribution: $DISTRO_LOWER"
    echo "This script only supports Ubuntu and Debian"
    exit 1
fi

# Verify VERSION_CODENAME exists
if [[ -z "$VERSION_CODENAME" ]]; then
    echo "ERROR: VERSION_CODENAME not found in /etc/os-release"
    echo "Your system may be too old or use a non-standard OS release format"
    exit 1
fi

echo "Detected: $DISTRO_LOWER $VERSION_CODENAME"

# Setup Docker Repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo wget -qO /etc/apt/keyrings/docker.asc "https://download.docker.com/linux/${DISTRO_LOWER}/gpg"
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Build the source list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/${DISTRO_LOWER} ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update

# Install Docker Engine
if ! sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras; then
    echo "ERROR: Failed to install Docker packages"
    exit 1
fi

# Verify Docker installed successfully
if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker command not available after installation"
    exit 1
fi

# Permissions & Logging
# Add user to group. Note: This requires a logout or 'newgrp docker' to work in the current session.
sudo usermod -aG docker "${USER}"

# Limit log size (Crucial for servers)
# We use -n to avoid overwriting if you've already customized this
if [ ! -f /etc/docker/daemon.json ]; then
    echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json
fi

echo "Docker installed!"
echo "NOTE: You may need to log out and back in for Docker group permissions to take effect."

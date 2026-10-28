#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "ERROR: Run this as your own user, not with sudo. It asks for sudo itself and adds \$USER to the docker group."
    exit 1
fi

echo "<--- installing docker... --->"

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

CODENAME="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
if [[ -z "$CODENAME" ]]; then
    echo "ERROR: No release codename found in /etc/os-release"
    echo "Your system may be too old or use a non-standard OS release format"
    exit 1
fi

echo "Detected: $DISTRO_LOWER $CODENAME"

# Setup Docker Repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL "https://download.docker.com/linux/${DISTRO_LOWER}/gpg" -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/${DISTRO_LOWER}
Suites: ${CODENAME}
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
# Older runs wrote the one-line format; leaving it would make apt warn about a duplicate source
sudo rm -f /etc/apt/sources.list.d/docker.list

sudo apt update

# Release upgrades disable the repo, so rerunning this on an existing install re-points it
if command -v docker >/dev/null 2>&1; then
    echo "Docker is already installed ($(docker --version)); repo set to $CODENAME"
    echo "Run 'sudo apt upgrade' to update it."
    exit 0
fi

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
if [[ ! -f /etc/docker/daemon.json ]]; then
    echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json
fi

echo "Docker installed!"
echo "NOTE: You may need to log out and back in for Docker group permissions to take effect."

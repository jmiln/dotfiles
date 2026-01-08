#!/usr/bin/env bash
set -euo pipefail

echo "<--- installing docker... --->"

# Setup Docker Repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Build the source list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update

# Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

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

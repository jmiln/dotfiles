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

echo "<--- installing lazydocker... --->"

# Wrapping in a subshell fixes SC2103 and removes the need for 'cd -'
(
    cd /tmp || exit # Fixes SC2164

    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

    # Using x86_64 as per your setup, but consider arch detection for portability
    curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"

    tar -xf lazydocker.tar.gz lazydocker
    sudo install lazydocker /usr/local/bin
    rm lazydocker.tar.gz lazydocker
)

echo "Docker and Lazydocker installed!"
echo "NOTE: You may need to log out and back in for Docker group permissions to take effect."

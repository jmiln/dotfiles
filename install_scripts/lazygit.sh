#!/usr/bin/env bash
set -euo pipefail

ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ARCH="x86_64"
elif [ "$ARCH" = "aarch64" ]; then
    ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

echo "<--- installing lazygit... --->"

# Using a subshell ( ... ) fixes SC2103.
# When this block ends, we are automatically back where we started.
(
    # Adding || exit fixes SC2164
    cd /tmp || exit

    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"

    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/

    # Cleanup before the subshell closes
    rm lazygit.tar.gz lazygit
)

# This part happens in your original directory
mkdir -p "$HOME/.config/lazygit/"
touch "$HOME/.config/lazygit/config.yml"

echo "Done!"

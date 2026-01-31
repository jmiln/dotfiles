#!/usr/bin/env bash

# Strict mode
set -Eeuo pipefail
trap 'echo "ERROR: Script failed on line $LINENO" >> "$log_file"' ERR

DOTFILES_DIR="$HOME/dotfiles"
log_file="$DOTFILES_DIR/install_progress_log.txt"
touch "$log_file"

# -----
# Specify which programs are installed from where
# -----
APT_PACKAGES=(
    build-essential curl git python3 software-properties-common
    unzip wget ripgrep fd-find jq jc bat
)
BREW_PACKAGES=(tmux eza git-delta lazygit jesseduffield/lazydocker/lazydocker)
NPM_PACKAGES=(neovim npm-check-updates @biomejs/biome pm2)

# -----
# Helper functions
# -----
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

logToFile() {
    printf '[%s] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >>"$log_file"
}

retry_command() {
    local max_attempts=3
    local attempt=1
    local delay=5

    while [ $attempt -le $max_attempts ]; do
        if "$@"; then
            return 0
        fi

        if [ $attempt -lt $max_attempts ]; then
            logToFile "Command failed (attempt $attempt/$max_attempts). Retrying in ${delay}s..."
            sleep $delay
            delay=$((delay * 2))
        fi
        attempt=$((attempt + 1))
    done

    logToFile "ERROR: Command failed after $max_attempts attempts: $*"
    return 1
}

setup_symlink() {
    local target=$1
    local alias_name=$2
    if command_exists "$target"; then
        ln -sf "$(command -v "$target")" "$HOME/.local/bin/$alias_name"
    fi
}

logToFile "Starting install for $USER on $(uname -s)"

# Check sudo access early to fail fast
if ! sudo -v; then
    logToFile "ERROR: This script requires sudo access"
    echo "ERROR: This script requires sudo access"
    exit 1
fi

# Check available disk space (need at least 5GB free)
available_space=$(df -BG "$HOME" | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$available_space" -lt 5 ]; then
    echo "WARNING: Low disk space. Available: ${available_space}GB, Recommended: 5GB+"
    logToFile "WARNING: Low disk space detected: ${available_space}GB"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Warn if createLinks.sh hasn't been run yet
if [[ ! -L "$HOME/.config/nvim" || ! -L "$HOME/.zshenv" ]]; then
    echo "WARNING: Critical symlinks missing. Did you run ./createLinks.sh first?"
    logToFile "WARNING: Symlinks not detected - createLinks.sh may not have run"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

if [[ "$(uname -s)" == "Linux" ]]; then
    if command_exists apt; then
        sudo apt update && sudo apt upgrade -y
        PKG_INSTALL="sudo apt install -y"
    else
        logToFile "ERROR: Only APT (Ubuntu/Debian) is supported"
        exit 1
    fi
fi

logToFile "Installing APT packages"
$PKG_INSTALL "${APT_PACKAGES[@]}"

# Link fd & bat so they'll play nice
setup_symlink fdfind fd
setup_symlink batcat bat

# -------------------------------
# Install zsh
# -------------------------------
if ! command_exists zsh; then
    $PKG_INSTALL zsh
    logToFile "zsh installed."
fi

# -------------------------------
# Change the default shell to zsh if necessary
# -------------------------------
ZSH_PATH="$(command -v zsh)"

if ! grep -qx "$ZSH_PATH" /etc/shells; then
    logToFile "ERROR: zsh is not listed in /etc/shells"
    exit 1
fi

if [[ "$(basename "$SHELL")" != "zsh" ]]; then
    logToFile "Default shell changed to zsh."
    sudo chsh -s "$ZSH_PATH" "$USER"
    echo ""
    echo "============================================"
    echo "NOTE: Default shell changed to zsh"
    echo "You must LOG OUT and LOG BACK IN for this to take effect"
    echo "============================================"
    echo ""
fi

# -------------------------------
# Install Homebrew
# -------------------------------
if ! command_exists brew; then
    logToFile "Homebrew not found. Installing Homebrew..."
    if ! retry_command bash -c 'NONINTERACTIVE=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'; then
        logToFile "ERROR: Failed to install Homebrew after multiple attempts"
        exit 1
    fi

    # Add brew to the current shell session's PATH
    logToFile "Adding Linuxbrew to PATH for this session..."
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    echo ""
    echo "============================================"
    echo "NOTE: Homebrew installed to /home/linuxbrew/.linuxbrew"
    echo "For new shells to find brew, you must LOG OUT and LOG BACK IN"
    echo "Or manually run: eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "============================================"
    echo ""
else
    logToFile "Homebrew is already installed."
fi

if ! command_exists brew; then
    logToFile "ERROR: brew command not available after installation"
    exit 1
else
    logToFile "Updating Homebrew and checking status..."
    brew update
    brew install "${BREW_PACKAGES[@]}"
fi

# -------------------------------
# Install Neovim
# - Install Rust if missing
# - Install Bob and Neovim
# -------------------------------
if ! command_exists cargo; then
    logToFile "Installing Rust..."
    if ! retry_command bash -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'; then
        logToFile "ERROR: Failed to install Rust"
        exit 1
    fi
    export PATH="$HOME/.cargo/bin:$PATH"
fi
if ! command_exists bob; then
    echo "Installing Bob (Neovim version manager)..."
    echo "This may take 5-10 minutes to compile..."
    cargo install bob-nvim

    # Add bob's nvim path to current session
    export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

    # Install nightly by default, with fallback to stable if it fails
    echo "Downloading and installing Neovim..."
    if ! bob use nightly; then
        logToFile "WARNING: Neovim nightly failed, falling back to stable"
        echo "WARNING: Neovim nightly build failed. Installing stable version instead."
        bob use stable
    fi
    logToFile "Neovim installed via Bob ($(bob list | grep '>' | awk '{print $2}'))"
fi

# ---
# Install FNM to install node/ npm
# ---
if ! command_exists fnm; then
    if ! retry_command bash -c 'curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell'; then
        logToFile "ERROR: Failed to install fnm"
        exit 1
    fi
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "$(fnm env)"

    if ! retry_command fnm install --lts; then
        logToFile "ERROR: Failed to install Node.js LTS"
        exit 1
    fi
    fnm default lts

    logToFile "fnm and the newest Node.js LTS installed."
fi

# Re-verify PATH for this process
export PATH="$HOME/.local/share/fnm:$PATH"
# Detect current shell (bash or sh/dash)
if [[ -n "$BASH_VERSION" ]]; then
    eval "$(fnm env --shell bash)"
else
    eval "$(fnm env --shell posix)"
fi

if command_exists npm; then
    logToFile "Installing Global NPM packages: ${NPM_PACKAGES[*]}"
    # Install packages and check for errors
    if npm install -g "${NPM_PACKAGES[@]}"; then
        logToFile "NPM packages installed successfully"
    else
        logToFile "WARNING: Some NPM packages may have failed to install"
        echo "WARNING: Some NPM packages may have failed. Check the output above."
    fi
else
    logToFile "ERROR: npm not found even after fnm install"
fi


# ---
# Install git integration for zsh
# ---
if command_exists git; then
    # Check if git is configured
    if ! git config --global user.name >/dev/null 2>&1 || ! git config --global user.email >/dev/null 2>&1; then
        echo ""
        echo "============================================"
        echo "WARNING: Git is not configured"
        echo "You should set your git identity with:"
        echo "  git config --global user.name \"Your Name\""
        echo "  git config --global user.email \"you@example.com\""
        echo "============================================"
        echo ""
        logToFile "WARNING: Git user.name or user.email not configured"
    fi

    mkdir -p "$HOME/.config/zsh"
    curl -fsSL https://github.com/git/git/raw/master/contrib/completion/git-completion.bash \
        -o "$HOME/.config/zsh/.git-completion.bash"

    logToFile "git-completion Installed and Configured"
fi

# ---
# Install tpm for tmux plugins
# --
if ! [ -d ~/.config/tmux/plugins/tpm ]; then
    mkdir -p "$HOME/.config/tmux/plugins"
    if git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"; then
        # Install the plugins
        if "$HOME/.config/tmux/plugins/tpm/bin/install_plugins"; then
            logToFile "TPM & plugins installed."
        else
            logToFile "WARNING: TPM cloned but plugin installation failed"
            echo ""
            echo "NOTE: TPM plugins may need manual installation"
            echo "After starting tmux, press 'Ctrl+Space' then 'I' to install plugins"
            echo ""
        fi
    else
        logToFile "ERROR: Failed to clone TPM repository"
    fi
else
    logToFile "TPM already installed."
fi

# Install fzf
if ! command_exists fzf; then
    rm -rf "$HOME/.local/share/.fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.local/share/.fzf"

    "$HOME/.local/share/.fzf/install" --bin
    ln -sf "$HOME/.local/share/.fzf/bin/fzf" "$HOME/.local/bin/fzf"
    logToFile "fzf installed."
else
    logToFile "fzf is already installed."
fi

if ! command_exists docker; then
    if [[ -f "$DOTFILES_DIR/install_scripts/docker.sh" ]]; then
        if bash "$DOTFILES_DIR/install_scripts/docker.sh"; then
            logToFile "Docker installation completed"
        else
            logToFile "WARNING: Docker installation failed or was skipped"
        fi
    else
        logToFile "Docker installation script not found"
    fi
fi

# Set timezone to US/Pacific
if [[ -f /usr/share/zoneinfo/America/Los_Angeles ]]; then
    sudo timedatectl set-timezone America/Los_Angeles 2>/dev/null || {
        logToFile "Could not set timezone (timedatectl not available)"
    }
    logToFile "Timezone set to America/Los_Angeles"
else
    logToFile "WARNING: Timezone file not found for America/Los_Angeles"
fi

#==============
# Go back to the dotfiles dir
#==============
cd "$DOTFILES_DIR"

#==============
# Give the user a summary of what has been installed
#==============
printf "\n====== Installation Summary ======\n"
cat "$log_file"

echo ""
echo "============================================"
echo "IMPORTANT POST-INSTALL NOTES:"
echo "============================================"
echo "1. LOG OUT and LOG BACK IN to activate:"
echo "   - zsh as default shell"
echo "   - Homebrew PATH"
echo ""
echo "2. First time launching zsh will be slow while Zinit"
echo "   downloads and installs shell plugins"
echo ""
echo "3. If tmux plugins didn't install automatically:"
echo "   - Start tmux"
echo "   - Press Ctrl+Space then I to install plugins"
echo ""
echo "============================================"

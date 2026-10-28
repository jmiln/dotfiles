#!/usr/bin/env bash

# Strict mode
set -Eeuo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "ERROR: Run this as your own user, not with sudo. It asks for sudo itself where needed."
    exit 1
fi

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
BREW_PACKAGES=(tmux eza fzf git-delta lazygit jesseduffield/lazydocker/lazydocker)
NPM_PACKAGES=(neovim npm-check-updates @biomejs/biome)
TIMEZONE="${1:-America/Los_Angeles}"

# -----
# Helper functions
# -----
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

log() {
    printf '[%s] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$log_file"
}

die() {
    log "ERROR: $*"
    exit 1
}

confirm() {
    local reply
    read -p "$1 (y/n) " -n 1 -r reply
    echo
    [[ $reply =~ ^[Yy]$ ]]
}

retry_command() {
    local max_attempts=3
    local attempt=1
    local delay=5

    while [[ $attempt -le $max_attempts ]]; do
        if "$@"; then
            return 0
        fi

        if [[ $attempt -lt $max_attempts ]]; then
            log "Command failed (attempt $attempt/$max_attempts). Retrying in ${delay}s..."
            sleep $delay
            delay=$((delay * 2))
        fi
        attempt=$((attempt + 1))
    done

    log "ERROR: Command failed after $max_attempts attempts: $*"
    return 1
}

setup_symlink() {
    local target=$1
    local alias_name=$2
    if command_exists "$target"; then
        ln -sf "$(command -v "$target")" "$HOME/.local/bin/$alias_name"
    fi
}

trap 'log "ERROR: Script failed on line $LINENO"' ERR

log "Starting install for $USER on $(uname -s)"

# Check sudo access early to fail fast
if ! sudo -v; then
    die "This script requires sudo access"
fi

# Check available disk space (need at least 5GB free)
available_space=$(df -BG "$HOME" | tail -1 | awk '{print $4}' | sed 's/G//')
if [[ "$available_space" -lt 5 ]]; then
    log "WARNING: Low disk space. Available: ${available_space}GB, Recommended: 5GB+"
    if ! confirm "Continue anyway?"; then
        exit 1
    fi
fi

# Warn if createLinks.sh hasn't been run yet
if [[ ! -L "$HOME/.config/nvim" || ! -L "$HOME/.zshenv" ]]; then
    log "WARNING: Critical symlinks missing. Did you run ./createLinks.sh first?"
    if ! confirm "Continue anyway?"; then
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
        die "Only APT (Ubuntu/Debian) is supported"
    fi
fi

log "Installing APT packages"
$PKG_INSTALL "${APT_PACKAGES[@]}"

# Link fd & bat so they'll play nice
setup_symlink fdfind fd
setup_symlink batcat bat

# -------------------------------
# Install zsh
# -------------------------------
if ! command_exists zsh; then
    $PKG_INSTALL zsh
    log "zsh installed."
fi

# -------------------------------
# Change the default shell to zsh if necessary
# -------------------------------
ZSH_PATH="$(command -v zsh)"

if ! grep -qx "$ZSH_PATH" /etc/shells; then
    die "zsh is not listed in /etc/shells"
fi

if [[ "$(basename "$SHELL")" != "zsh" ]]; then
    log "Default shell changed to zsh."
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
    log "Homebrew not found. Installing Homebrew..."
    if ! retry_command bash -c 'NONINTERACTIVE=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'; then
        die "Failed to install Homebrew after multiple attempts"
    fi

    # Add brew to the current shell session's PATH
    log "Adding Linuxbrew to PATH for this session..."
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    echo ""
    echo "============================================"
    echo "NOTE: Homebrew installed to /home/linuxbrew/.linuxbrew"
    echo "For new shells to find brew, you must LOG OUT and LOG BACK IN"
    echo "Or manually run: eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "============================================"
    echo ""
else
    log "Homebrew is already installed."
fi

if ! command_exists brew; then
    die "brew command not available after installation"
else
    log "Updating Homebrew and checking status..."
    brew update
    brew install "${BREW_PACKAGES[@]}"
fi

# -------------------------------
# Install Neovim
# - Install Rust if missing
# - Install Bob and Neovim
# -------------------------------
if ! command_exists cargo; then
    log "Installing Rust..."
    if ! retry_command bash -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'; then
        die "Failed to install Rust"
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
        log "WARNING: Neovim nightly failed, falling back to stable"
        bob use stable
    fi
    log "Neovim installed via Bob ($(bob list | grep '>' | awk '{print $2}'))"
fi

# ---
# Install FNM to install node/ npm
# ---
if ! command_exists fnm; then
    if ! retry_command bash -c 'curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell'; then
        die "Failed to install fnm"
    fi
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "$(fnm env)"

    if ! retry_command fnm install --lts; then
        die "Failed to install Node.js LTS"
    fi
    fnm default lts

    log "fnm and the newest Node.js LTS installed."
fi

# Re-verify PATH for this process
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --shell bash)"

if command_exists npm; then
    log "Installing Global NPM packages: ${NPM_PACKAGES[*]}"
    # Install packages and check for errors
    if npm install -g "${NPM_PACKAGES[@]}"; then
        log "NPM packages installed successfully"
    else
        log "WARNING: Some NPM packages may have failed to install. Check the output above."
    fi
else
    log "ERROR: npm not found even after fnm install"
fi


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
        log "WARNING: Git user.name or user.email not configured"
    fi
fi

# ---
# Install tpm for tmux plugins
# --
if [[ ! -d "$HOME/.config/tmux/plugins/tpm" ]]; then
    mkdir -p "$HOME/.config/tmux/plugins"
    if git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"; then
        # Install the plugins
        if "$HOME/.config/tmux/plugins/tpm/bin/install_plugins"; then
            log "TPM & plugins installed."
        else
            log "WARNING: TPM cloned but plugin installation failed"
            echo ""
            echo "NOTE: TPM plugins may need manual installation"
            echo "After starting tmux, press 'Ctrl+Space' then 'I' to install plugins"
            echo ""
        fi
    else
        log "ERROR: Failed to clone TPM repository"
    fi
else
    log "TPM already installed."
fi

if ! command_exists docker; then
    if ! confirm "Install Docker?"; then
        log "Docker install skipped"
    elif [[ -f "$DOTFILES_DIR/install_scripts/docker.sh" ]]; then
        if bash "$DOTFILES_DIR/install_scripts/docker.sh"; then
            log "Docker installation completed"
        else
            log "WARNING: Docker installation failed or was skipped"
        fi
    else
        log "Docker installation script not found"
    fi
fi

if ! confirm "Set timezone to $TIMEZONE?"; then
    read -r -p "Timezone to use instead (e.g. America/New_York, blank to skip): " TIMEZONE || TIMEZONE=""
fi
if [[ -z "$TIMEZONE" ]]; then
    log "Timezone left unchanged"
elif [[ ! -f "/usr/share/zoneinfo/$TIMEZONE" ]]; then
    log "WARNING: Unknown timezone '$TIMEZONE', left unchanged"
elif sudo timedatectl set-timezone "$TIMEZONE" 2>/dev/null; then
    log "Timezone set to $TIMEZONE"
else
    log "WARNING: Could not set timezone (timedatectl not available)"
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

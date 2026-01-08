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
BREW_PACKAGES=(tmux eza git-delta lazygit)
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

setup_symlink() {
    local target=$1
    local alias_name=$2
    if command_exists "$target"; then
        ln -sf "$(command -v "$target")" "$HOME/.local/bin/$alias_name"
    fi
}

logToFile "Starting install for $USER on $(uname -s)"
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
fi

# -------------------------------
# Install Homebrew
# -------------------------------
if ! command_exists brew; then
    logToFile "Homebrew not found. Installing Homebrew..."
    NONINTERACTIVE=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to the current shell session's PATH
    logToFile "Adding Linuxbrew to PATH for this session..."
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
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
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    export PATH="$HOME/.cargo/bin:$PATH"
fi
if ! command_exists bob; then
    cargo install bob-nvim

    # Add bob's nvim path to current session
    export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

    bob use nightly
    logToFile "Neovim installed via Bob"
fi

# ---
# Install FNM to install node/ npm
# ---
if ! command_exists fnm; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "$(fnm env)"
    fnm install --lts
    fnm default lts

    logToFile "fnm and the newest Node.js LTS installed."
fi

# Re-verify PATH for this process
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --shell bash)"

if command_exists npm; then
    logToFile "Installing Global NPM packages: ${NPM_PACKAGES[*]}"
    # Using --quiet to keep the log file readable
    npm install -g "${NPM_PACKAGES[@]}" --quiet
else
    logToFile "ERROR: npm not found even after fnm install"
fi


# ---
# Install git integration for zsh
# ---
if command_exists git; then
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
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"

    # Install the plugins
    "$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
    logToFile "TPM & plugins installed."
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

[[ -f "$DOTFILES_DIR/install_scripts/docker.sh" ]] && bash "$DOTFILES_DIR/install_scripts/docker.sh"
[[ -f "$DOTFILES_DIR/install_scripts/lazygit.sh" ]] && bash "$DOTFILES_DIR/install_scripts/lazygit.sh"

#==============
# Go back to the dotfiles dir
#==============
cd "$DOTFILES_DIR"

#==============
# Give the user a summary of what has been installed
#==============
printf "\n====== Installation Summary ======\n"
cat "$log_file"

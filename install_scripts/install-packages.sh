#!/usr/bin/env bash

# Set the file to log to as we go
touch ~/install_progress_log.txt
log_file=~/install_progress_log.txt

# Grab where this is
DOTFILES_DIR=$(pwd)

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

logToFile() {
    echo $@ >> $log_file
}

OS=$(uname)
log "Detected OS: $OS"

if [ "$OS" == "Linux" ]; then
    log "Running Linux specific commands..."
    if command -v apt >/dev/null 2>&1; then
        log "Using apt to update Linux..."
        sudo apt update && sudo apt upgrade -y
    elif command -v apt-get >/dev/null 2>&1; then
        log "Using apt-get to update Linux..."
        sudo apt-get update && sudo apt-get upgrade -y
    fi
fi

# -------------------------------
# Install zsh
# -------------------------------
if ! command_exists zsh; then
    sudo apt install -y zsh
    logToFile "zsh installed."
else
    logToFile "zsh is already installed."
fi

# -------------------------------
# Change the default shell to zsh if necessary
# -------------------------------
if [ "$(basename "$SHELL")" != "zsh" ]; then
    logToFile "zsh is not the default shell. Changing the default shell to zsh..."
    if command -v zsh >/dev/null 2>&1; then
        sudo chsh -s "$(which zsh)" "$USER"
        logToFile "Default shell has been changed to zsh."
    else
        logToFile "ERROR: zsh command not found, cannot change shell."
        exit 1
    fi
fi

## This is now taken care of by plugins in .zshrc
# cd /usr/share
# sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# sudo apt-get install zsh-syntax-highlighting

dependencies = (
    build-essential
    curl
    git
    python3
    software-properties-common
    unzip
    wget
)

for dependency in "${dependencies[@]}"; do
    if ! command_exists $dependency; then
        sudo apt install -y $dependency
        logToFile "$dependency installed."
    else
        logToFile "$dependency is already installed."
    fi
done


# ---
# Install FNM to install node/ npm
# ---
if ! command_exists fnm; then
    curl -fsSL https://fnm.vercel.app/install | bash
    eval "$(fnm env)"
    fnm install --lts
    logToFile "fnm and the newest Node.js LTS installed."
else
    logToFile "fnm is already installed."
fi


# ---
# Install git integration for zsh
# ---
if command_exists git; then
    curl https://github.com/git/git/raw/master/contrib/completion/git-completion.bash -o ~/.config/zsh/.git-completion.bash
    curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.config/zsh/.git-prompt.sh

    logToFile "Git & git-completion and git-prompt Installed and Configured"
fi


# ---
# Install tmux & tpm
# --
if ! command_exists tmux; then
    sudo apt install -y tmux
    logToFile "Tmux installed."
else
    logToFile "Tmux is already installed."
fi

if ! [ -d ~/.config/tmux/plugins/tpm ]; then
    mkdir -p ~/.config/tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    logToFile "TPM installed. Run 'prefix + I' to install plugins."
fi

# Install ripgrep & fd (Mainly for nvim telescope)
if ! command_exists rg; then
    sudo apt install ripgrep
    logtoFile "Ripgrep installed."
fi
if ! command_exists fdfind; then
    sudo apt install fd-find
    mkdir -p ~/.local/bin
    ln -s $(which fdfind) ~/.local/bin/fd
    logToFile "fd installed."
fi

# Install nvim normal
if ! command_exists nvim; then
    # Add the repo & install neovim (unstable/ nightly) itself
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt -y install neovim python3-neovim

    # Update to alias vim, vi & $EDITOR to neovim
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    sudo update-alternatives --config vi
    sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
    sudo update-alternatives --config vim
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    sudo update-alternatives --config editor
    logToFile "Neovim installed."
else
    logToFile "Neovim is already installed."
fi

# JSON utilities
if ! command_exists jq; then
    sudo apt install jq -y
    logToFile "JQ installed"
else
    logToFile "JQ is already installed"
fi

if ! command_exists jc; then
    sudo apt install jc -y
    logToFile "JC installed"
else
    logToFile "JC is already installed"
fi

# Install lua-language-server for nvim config files mainly
if ! command_exists lua-language-server; then
    # Get the latest version available
    wget -q -O ~/tmp/lua-language-server.tar.gz $(wget -q -O - 'https://api.github.com/repos/LuaLS/lua-language-server/releases/latest' | jq -r '.assets[] | select(.name | match("lua-language-server.*linux-x64.tar.gz$")).browser_download_url')

    # Clear out any old versions
    rm -rf ~/.local/share/lua-language-server
    rm ~/.local/bin/lua-language-server

    # Create the folders in case they're needed/ not there
    mkdir -p ~/.local/share/lua-language-server
    mkdir -p ~/.local/bin

    # Extract the bits and link em where needed
    tar -xzf ~/tmp/lua-language-server.tar.gz -C ~/.local/share/lua-language-server
    ln -s ~/.local/share/lua-language-server/bin/lua-language-server ~/.local/bin/lua-language-server

    # Clean up the downloaded package
    rm -rf ~/tmp/lua-language-server.tar.gz
fi

if ! command_exists eza; then
    sudo apt install eza
    logToFile "eza installed."
fi

if ! command_exists bat && ! command_exists batcat; then
    sudo apt install bat
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
    logToFile "bat installed."
fi

# Install the normal global nodejs packages that I end up using
if command_exists npm; then
    npm install -g neovim npm-check-updates @biomejs/biome pm2 typescript typescript-language-server vscode-langservers-extracted
    logToFile "npm global packages installed."
fi

# Install fzf
if ! command_exists fzf; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.local/scripts/.fzf
    # ~/.fzf/install
    logToFile "fzf installed."
else
    logToFile "fzf is already installed."
fi

if ! command_exists docker; then
    bash ~/dotfiles/install_scripts/docker.sh
    logToFile "Docker installed."
fi

if ! command_exists lazygit; then
    bash ~/dotfiles/install_scripts/lazygit.sh
    logToFile "Lazygit installed."
fi

#==============
# Go back to the dotfiles dir
#==============
cd $DOTFILES_DIR

#==============
# Give the user a summary of what has been installed
#==============
echo -e "\n====== Summary ======\n"
cat $log_file
echo
rm $log_file

#!/usr/bin/env bash

# Set the file to log to as we go
log_file=~/install_progress_log.txt

# Grab where this is
dotfilesDir=$(pwd)

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

logToFile() {
    echo $@ >> $log_file
}

# Update package list
sudo apt update

if ! command_exists zsh; then
    sudo apt install -y zsh
    chsh -s $(which zsh)
    logToFile "zsh installed and set as default shell."
else
    logToFile "zsh is already installed."
fi

## This is now taken care of by plugins in .zshrc
# cd /usr/share
# sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# sudo apt-get install zsh-syntax-highlighting

if ! command_exists curl; then
    sudo apt install -y curl
    logToFile "curl installed."
else
    logToFile "curl is already installed."
fi

if ! command_exists wget; then
    sudo apt install -y wget
    logToFile "wget installed."
else
    logToFile "wget is already installed."
fi

# ---
# Install NVM to install node/ npm
# ---
if ! command_exists nvm; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    logToFile "nvm and the newest Node.js LTS installed."
else
    logToFile "nvm is already installed."
fi

if ! command_exists git; then
    sudo apt install -y git

    curl https://github.com/git/git/raw/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
    curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh

    logToFile "Git & git-completion and git-prompt Installed and Configured"
else
    logToFile "Git is already installed."
fi

sudo apt -y install build-essential
logToFile "Installed build-essential"


# ---
# Install tmux
# --
if ! command_exists tmux; then
    sudo apt install -y tmux

    mkdir -p ~/.config/tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

    logToFile "Tmux & TPM installed."
else
    logToFile "Tmux is already installed."
fi

# Make sure both versions of python are installed
sudo apt-get -y install python2 python3

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

if ! command_exists eza; then
    sudo apt install exa
    logToFile "exa installed."
fi

# Install the normal global nodejs packages that I end up using
if command_exists npm; then
    npm install -g neovim npm-check-updates @biomejs/biome pm2 typescript typescript-language-server vscode-langservers-extracted
    logToFile "npm global packages installed."
fi

#==============
# Go back to the dotfiles dir
#==============
cd $dotfilesDir

#==============
# Give the user a summary of what has been installed
#==============
echo -e "\n====== Summary ======\n"
cat $log_file
echo
rm $log_file

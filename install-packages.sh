#!/usr/bin/env bash

# Set the file to log to as we go
log_file=~/install_progress_log.txt

# Grab where this is
dotfilesDir=$(pwd)

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update package list
sudo apt update

if ! command_exists zsh; then
    sudo apt install -y zsh
    chsh -s $(which zsh)
    echo "zsh installed and set as default shell." >> $log_file
else
    echo "zsh is already installed." >> $log_file
fi

cd /usr/share
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# sudo apt-get install zsh-syntax-highlighting

if ! command_exists curl; then
    sudo apt install -y curl
    echo "curl installed." >> $log_file
else
    echo "curl is already installed." >> $log_file
fi

if ! command_exists wget; then
    sudo apt install -y wget
    echo "wget installed." >> $log_file
else
    echo "wget is already installed." >> $log_file
fi

# ---
# Install NVM to install node/ npm
# ---
if ! command_exists nvm; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    echo "nvm and the newest Node.js LTS installed." >> $log_file
else
    echo "nvm is already installed." >> $log_file
fi

if ! command_exists git; then
    sudo apt install -y git
    echo "git installed." >> $log_file
else
    echo "git is already installed." >> $log_file
fi

sudo apt -y install build-essential
echo "Installed build-essential" >> $log_file

# ---
# Install git-completion and git-prompt
# ---
cd ~/
curl https://github.com/git/git/raw/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
echo "git-completion and git-prompt Installed and Configured" >> $log_file


# ---
# Install tmux
# --
if ! command_exists tmux; then
    sudo apt install -y tmux
    echo "tmux installed." >> $log_file
else
    echo "tmux is already installed." >> $log_file
fi

# ---
# Install a package manager for tmux
# --
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
echo "Installed TPM (Tmux Plugin Manager)" >> $log_file

# Make sure both versions of python are installed
sudo apt-get -y install python2 python3

# Install ripgrep & fd (Mainly for nvim telescope)
sudo apt install ripgrep
sudo apt install fd-find
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd

# Install nvim normal
if command_exists nvim; then
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
    echo "Neovim installed." >> $log_file
fi

# Install the normal global nodejs packages that I end up using
if command_exists npm; then
    npm install -g neovim npm-check-updates @biomejs/biome pm2 typescript typescript-language-server vscode-langservers-extracted
    echo "npm global packages installed." >> $log_file
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

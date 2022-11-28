#!/usr/bin/env bash

# Set the file to log to as we go
log_file=~/install_progress_log.txt

# Grab where this is
dotfilesDir=$(pwd)

sudo apt-get -y install zsh
if type -p zsh > /dev/null; then
    echo "zsh Installed" >> $log_file
else
    echo "zsh FAILED TO INSTALL!!!" >> $log_file
fi

cd /usr/share
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# sudo apt-get install zsh-syntax-highlighting

sudo apt-get -y install curl
if type -p curl > /dev/null; then
    echo "curl Installed" >> $log_file
else
    echo "curl FAILED TO INSTALL!!!" >> $log_file
fi

# ---
# Install NVM to install node/ npm
# ---
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
echo "NVM downloaded"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install node
echo "Node/npm installed"

sudo apt -y install build-essential
echo "Installed build-essential"

# ---
# Install git-completion and git-prompt
# ---
cd ~/
curl -OL https://github.com/git/git/raw/master/contrib/completion/git-completion.bash
mv ~/git-completion.bash ~/.git-completion.bash
curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
echo "git-completion and git-prompt Installed and Configured" >> $log_file


# ---
# Install tmux
# --
sudo apt-get -y install tmux
if type -p tmux > /dev/null; then
    echo "tmux Installed" >> $log_file
else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
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
if command -v nvim &> /dev/null; then
    # Python stuff for older OS installs
    # sudo apt -y install software-properties-common
    # sudo apt-get install python-dev python-pip python3-dev python3-pip

    # For current installs, we seem to just need this
    sudo apt -y install python3-dev python3-pip

    # Add the repo & install neovim (unstable/ nightly) itself
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt -y install neovim

    # Update to alias vim, vi & $EDITOR to neovim
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    sudo update-alternatives --config vi
    sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
    sudo update-alternatives --config vim
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    sudo update-alternatives --config editor
fi

#==============
# Set zsh as the default shell
#==============
# chsh -s /bin/zsh

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

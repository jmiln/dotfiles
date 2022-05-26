#!/bin/zsh
#===============================================================================
#
#             NOTES: For this to work you must have cloned the github
#                    repo to your home folder as ~/dotfiles/
#
#===============================================================================

#==============
# Variables
#==============
dotfiles_dir=~/dotfiles

#==============
# Delete existing dot files and folders
#==============
sudo rm -rf ~/.aliases > /dev/null 2>&1
sudo rm -rf ~/.bashrc > /dev/null 2>&1
sudo rm -rf ~/.config/nvim > /dev/null 2>&1
sudo rm -rf ~/.gitconfig > /dev/null 2>&1
sudo rm -rf ~/.git-prompt.sh > /dev/null 2>&1
sudo rm -rf ~/.functions > /dev/null 2>&1
sudo rm -rf ~/.inputrc > /dev/null 2>&1
sudo rm -rf ~/.profile > /dev/null 2>&1
sudo rm -rf ~/.tmux.conf > /dev/null 2>&1
sudo rm -rf ~/.vim > /dev/null 2>&1
sudo rm -rf ~/.vimrc > /dev/null 2>&1
sudo rm -rf ~/.zshrc > /dev/null 2>&1


#==============
# Create ~/.config just in case
#==============
mkdir -p ~/.config

#==============
# Create symlinks in the home folder
#==============
ln -sf $dotfiles_dir/aliases            ~/.aliases
ln -sf $dotfiles_dir/bashrc             ~/.bashrc
ln -sf $dotfiles_dir/git/gitconfig      ~/.gitconfig
ln -sf $dotfiles_dir/zsh/git-prompt.sh  ~/.git-prompt.sh
ln -sf $dotfiles_dir/functions          ~/.functions
ln -sf $dotfiles_dir/inputrc            ~/.inputrc
ln -sf $dotfiles_dir/nvim               ~/.config/nvim
ln -sf $dotfiles_dir/profile            ~/.profile
ln -sf $dotfiles_dir/tmux.conf          ~/.tmux.conf
ln -sf $dotfiles_dir/vim/               ~/.vim
ln -sf $dotfiles_dir/zsh/zshrc          ~/.zshrc

#==============
# Set zsh as the default shell
#==============
#sudo chsh -s /bin/zsh

#==============
# Give the user a summary of what has been installed
#==============
echo -e "\nDone\n"

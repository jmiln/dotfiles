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
# The dotfiles dir, where this script probably is
DOTFILES_DIR=~/dotfiles

# Grab which OS is being used (Useful later)
_myos="$(uname)"

#==============
# Delete existing dot files and folders
#==============
rm -rf ~/.aliases                   > /dev/null 2>&1
rm -rf ~/.config/scripts/.aliases   > /dev/null 2>&1
rm -rf ~/.bashrc                    > /dev/null 2>&1
rm -rf ~/.config/btop/btop.conf     > /dev/null 2>&1
rm -rf ~/.functions                 > /dev/null 2>&1
rm -rf ~/.config/scripts/.functions > /dev/null 2>&1
rm -rf ~/.gitconfig                 > /dev/null 2>&1
rm -rf ~/.git-prompt.sh             > /dev/null 2>&1
rm -rf ~/.config/htop/htoprc        > /dev/null 2>&1
rm -rf ~/.inputrc                   > /dev/null 2>&1
rm -rf ~/.mongoshrc.js              > /dev/null 2>&1
rm -rf ~/.config/nvim               > /dev/null 2>&1
rm -rf ~/.profile                   > /dev/null 2>&1
rm -rf ~/.tmux.conf                 > /dev/null 2>&1
rm -rf ~/.config/tmux/tmux.conf     > /dev/null 2>&1
rm -rf ~/.vim                       > /dev/null 2>&1
rm -rf ~/.vimrc                     > /dev/null 2>&1
rm -rf ~/.zshrc                     > /dev/null 2>&1
rm -rf ~/.config/zsh/*              > /dev/null 2>&1


#==============
# Create ~/.config just in case
#==============

#==============
# Create symlinks in the home folder
#==============
# Symlink differently depending on the OS
case $_myos in
    # Linux (Clearly)
    Linux)
        mkdir -p ~/.config/btop
        mkdir -p ~/.config/tmux
        mkdir -p ~/.config/zsh
        mkdir -p ~/.config/scripts

        # Zsh / shell locations
        mkdir -p ~/.cache
        mkdir -p ~/.local/bin
        mkdir -p ~/.local/share
        mkdir -p ~/.local/state/zsh
        mkdir -p ~/.local/scripts

        ln -sf $DOTFILES_DIR/aliases            ~/.config/scripts/.aliases
        ln -sf $DOTFILES_DIR/bash/bashrc        ~/.bashrc
        ln -sf $DOTFILES_DIR/btop.conf          ~/.config/btop/btop.conf
        ln -sf $DOTFILES_DIR/functions          ~/.config/scripts/.functions
        ln -sf $DOTFILES_DIR/git/gitconfig      ~/.gitconfig
        ln -sf $DOTFILES_DIR/htoprc             ~/.config/htop/htoprc
        ln -sf $DOTFILES_DIR/inputrc            ~/.inputrc
        ln -sf $DOTFILES_DIR/mongoshrc.js       ~/.mongoshrc.js
        ln -sf $DOTFILES_DIR/nvim               ~/.config/nvim
        ln -sf $DOTFILES_DIR/profile            ~/.profile
        ln -sf $DOTFILES_DIR/tmux.conf          ~/.config/tmux/tmux.conf
        ln -sf $DOTFILES_DIR/vim/               ~/.vim
        ln -sf $DOTFILES_DIR/zsh/git-prompt.sh  ~/.config/zsh/.git-prompt.sh
        ln -sf $DOTFILES_DIR/zsh/zshenv         ~/.zshenv
        ln -sf $DOTFILES_DIR/zsh/zshrc          ~/.config/zsh/.zshrc

        # Tmux todo popup
        ln -sf $DOTFILES_DIR/scripts/find_todo_file.sh ~/.local/bin/find_todo_file.sh
    ;;
    # Default case (None of the above)
    *);;
esac


#==============
# Give the user a summary of what has been installed
#==============
echo -e "\nDone\n"

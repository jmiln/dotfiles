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
dotfiles_dir=~/dotfiles

# Grab which OS is being used (Useful later)
_myos="$(uname)"

#==============
# Delete existing dot files and folders
#==============
rm -rf ~/.aliases                   > /dev/null 2>&1
rm -rf ~/.bashrc                    > /dev/null 2>&1
rm -rf ~/.functions                 > /dev/null 2>&1
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


#==============
# Create ~/.config just in case
#==============
mkdir -p ~/.config/htop
mkdir -p ~/.config/tmux

#==============
# Create symlinks in the home folder
#==============
# Symlink differently depending on the OS
case $_myos in
    # Windows / Git Bash
    *MINGW64*)
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/aliases            ~/.aliases
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/bashrc             ~/.bashrc
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/functions          ~/.functions
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/git/gitconfig      ~/.gitconfig
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/zsh/git-prompt.sh  ~/.git-prompt.sh
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/htoprc             ~/.config/htop/htoprc
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/inputrc            ~/.inputrc
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/mongoshrc.js       ~/.mongoshrc.js
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/nvim               ~/.config/nvim
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/profile            ~/.profile
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/tmux.conf          ~/.config/tmux/tmux.conf
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/vim/               ~/.vim            # This has the vimrc inside it
        MSYS=winsymlinks:nativestrict ln -sf $dotfiles_dir/zsh/zshrc          ~/.zshrc
    ;;

    # Linux (Clearly)
    Linux)
        ln -sf $dotfiles_dir/aliases            ~/.aliases
        ln -sf $dotfiles_dir/bashrc             ~/.bashrc
        ln -sf $dotfiles_dir/git/gitconfig      ~/.gitconfig
        ln -sf $dotfiles_dir/zsh/git-prompt.sh  ~/.git-prompt.sh
        ln -sf $dotfiles_dir/functions          ~/.functions
        ln -sf $dotfiles_dir/htoprc             ~/.config/htop/htoprc
        ln -sf $dotfiles_dir/inputrc            ~/.inputrc
        ln -sf $dotfiles_dir/mongoshrc.js       ~/.mongoshrc.js
        ln -sf $dotfiles_dir/nvim               ~/.config/nvim
        ln -sf $dotfiles_dir/profile            ~/.profile
        ln -sf $dotfiles_dir/tmux.conf          ~/.config/tmux/tmux.conf
        ln -sf $dotfiles_dir/vim/               ~/.vim
        ln -sf $dotfiles_dir/zsh/zshrc          ~/.zshrc
    ;;
    # Default case (None of the above)
    *);;
esac



#==============
# Set zsh as the default shell
#==============
#sudo chsh -s /bin/zsh

#==============
# Give the user a summary of what has been installed
#==============
echo -e "\nDone\n"

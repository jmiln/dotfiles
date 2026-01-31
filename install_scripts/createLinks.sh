#!/usr/bin/env bash

#===============================================================================
#
#             NOTES: For this to work you must have cloned the github
#                    repo to your home folder as ~/dotfiles/
#
#===============================================================================

# Strict mode
set -euo pipefail
IFS=$'\n\t'

#==============
# Variables
#==============
# The dotfiles dir, where this script probably is
DOTFILES_DIR="$HOME/dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Error: dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

# Grab which OS is being used (Useful later)
MY_OS="$(uname -s)"

ensure_dir() {
    mkdir -p "$1"
}

force_link() {
    local src="$1"
    local dst="$2"

    # If destination exists and is not already the correct link
    if [[ -e "$dst" || -L "$dst" ]]; then
        # Check if it's already the correct symlink
        if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
            echo "  ✓ Already linked correctly: $dst"
            return 0
        fi

        # Backup existing file/directory
        local backup="${dst}.bak"
        echo "  → Backing up existing: $dst to $backup"
        # Remove old backup if exists
        [[ -e "$backup" ]] && rm -rf "$backup"
        mv "$dst" "$backup"
    fi

    # Ensure parent directory exists
    ensure_dir "$(dirname "$dst")"

    # Create the symlink
    ln -sfn "$src" "$dst"
    echo "  ✓ Linked: $dst -> $src"
}

declare -A LINKS=(
    ["$DOTFILES_DIR/alacritty"]="$HOME/.config/alacritty"
    ["$DOTFILES_DIR/aliases"]="$HOME/.config/scripts/.aliases"
    ["$DOTFILES_DIR/bash/bashrc"]="$HOME/.bashrc"
    ["$DOTFILES_DIR/btop.conf"]="$HOME/.config/btop/btop.conf"
    ["$DOTFILES_DIR/functions"]="$HOME/.config/scripts/.functions"
    ["$DOTFILES_DIR/git/gitconfig"]="$HOME/.gitconfig"
    ["$DOTFILES_DIR/htoprc"]="$HOME/.config/htop/htoprc"
    ["$DOTFILES_DIR/inputrc"]="$HOME/.inputrc"
    ["$DOTFILES_DIR/mongoshrc.js"]="$HOME/.mongoshrc.js"
    ["$DOTFILES_DIR/nvim"]="$HOME/.config/nvim"
    ["$DOTFILES_DIR/profile"]="$HOME/.profile"
    ["$DOTFILES_DIR/tmux.conf"]="$HOME/.config/tmux/tmux.conf"
    ["$DOTFILES_DIR/vim"]="$HOME/.vim"
    ["$DOTFILES_DIR/zsh/git-prompt.sh"]="$HOME/.config/zsh/.git-prompt.sh"
    ["$DOTFILES_DIR/zsh/zshenv"]="$HOME/.zshenv"
    ["$DOTFILES_DIR/zsh/zshrc"]="$HOME/.config/zsh/.zshrc"
    ["$DOTFILES_DIR/scripts/find_todo_file.sh"]="$HOME/.local/bin/find_todo_file.sh"
)

#=============
# Paths to wipe out or create
#==============
LEGACY_PATHS=( # Wipe these out
    "$HOME/.aliases"
    "$HOME/.functions"
    "$HOME/.tmux.conf"
    "$HOME/.vimrc"
    "$HOME/.zshrc"
)

REQUIRED_DIRS=( # Ensure these exist
    "$HOME/.config/btop"
    "$HOME/.config/tmux"
    "$HOME/.config/zsh"
    "$HOME/.config/scripts"
    "$HOME/.cache"
    "$HOME/.local/bin"
    "$HOME/.local/share"
    "$HOME/.local/state/zsh"
    "$HOME/.local/scripts"
)

#==============
# Create symlinks in the home folder
# Mainly just linux, but in case I need it on Mac or something someday
#==============

case "$MY_OS" in
# Linux (Clearly)
Linux)
    for path in "${LEGACY_PATHS[@]}"; do
        rm -rf "$path"
    done

    for dir in "${REQUIRED_DIRS[@]}"; do
        ensure_dir "$dir"
    done

    for src in "${!LINKS[@]}"; do
        dst="${LINKS[$src]}"

        [[ -e "$src" ]] || {
            echo "Missing source: $src"
            exit 1
        }

        force_link "$src" "$dst"
    done
    ;;
# Default case (None of the above)
*) ;;
esac

echo "Links created"

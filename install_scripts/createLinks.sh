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

# Colors
DIM='\033[2m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
RESET='\033[0m'

ALREADY_LINKED=()
NEWLY_LINKED=()
BACKED_UP=()

ensure_dir() {
    mkdir -p "$1"
}

force_link() {
    local src="$1"
    local dst="$2"

    if [[ -e "$dst" || -L "$dst" ]]; then
        if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
            ALREADY_LINKED+=("$dst")
            return 0
        fi

        local backup="${dst}.bak"
        [[ -e "$backup" ]] && rm -rf "$backup"
        mv "$dst" "$backup"
        BACKED_UP+=("$dst -> $backup")
    fi

    ensure_dir "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    NEWLY_LINKED+=("$dst -> $src")
}

print_section() {
    local header="$1"
    local color="$2"
    shift 2
    local items=("$@")

    echo -e "\n${color}${BOLD}${header}${RESET}"
    for item in "${items[@]}"; do
        echo -e "  ${color}${item}${RESET}"
    done
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
    ["$DOTFILES_DIR/npmrc"]="$HOME/.npmrc"
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

    [[ ${#NEWLY_LINKED[@]}  -gt 0 ]] && print_section "Linked:"         "$GREEN"  "${NEWLY_LINKED[@]}"
    [[ ${#BACKED_UP[@]}     -gt 0 ]] && print_section "Backed up:"      "$YELLOW" "${BACKED_UP[@]}"
    [[ ${#ALREADY_LINKED[@]} -gt 0 ]] && print_section "Already linked:" "$DIM"    "${ALREADY_LINKED[@]}"

    echo ""
    ;;
# Default case (None of the above)
*) ;;
esac

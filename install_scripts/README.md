# Linux Installation Scripts

These scripts set up a new Linux system with dotfiles and development tools.

## Prerequisites

- **Sudo access required** for both scripts
- **Supported distributions:** Ubuntu and Debian
- **Repository location:** Must be cloned to `~/dotfiles`

## Installation Order

Run the scripts in this order:

### 1. Create Symlinks

```bash
./createLinks.sh
```

Creates symlinks from `~/dotfiles` to their system locations (e.g., `~/.config/nvim`, `~/.zshrc`).

**What it does:**
- Removes legacy config files from `~/.aliases`, `~/.tmux.conf`, etc.
- Creates required directories (`~/.config`, `~/.local`, etc.)
- Symlinks all dotfiles to proper locations
- Backs up existing files to `.bak` if they exist

### 2. Install Packages

```bash
./install-packages.sh
```

Installs all dependencies and development tools.

**What it does:**
- Updates system packages via APT
- Installs Homebrew and brew packages (tmux, eza, lazygit, etc.)
- Installs Rust/Cargo for Bob neovim manager
- Installs FNM (Fast Node Manager) and Node.js LTS
- Installs global npm packages
- Installs tmux plugin manager and plugins
- Installs fzf (fuzzy finder)
- Changes default shell to zsh
- Optionally installs Docker (via docker.sh)

**Installation log:** Progress is logged to `~/dotfiles/install_progress_log.txt`

### 3. Docker (Optional)

Docker is automatically installed by `install-packages.sh` if not already present. You can also run it manually:

```bash
./docker.sh
```

**Note:** After Docker installation, log out and back in for group permissions to take effect.

## Troubleshooting

- **"Permission denied"**: Make sure scripts are executable (`chmod +x *.sh`)
- **"This script requires sudo access"**: Run with a user that has sudo privileges
- **"dotfiles directory not found"**: Clone the repository to `~/dotfiles`
- **Docker group permissions**: Run `newgrp docker` or log out/in after Docker install
- **Check the log**: Review `~/dotfiles/install_progress_log.txt` for detailed output

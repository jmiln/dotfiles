# Linux Installation Scripts

These scripts set up a new Linux system with dotfiles and development tools.

## Prerequisites

- **Run as your own user**, not with `sudo`: `install-packages.sh` and `docker.sh` ask for sudo
  themselves, and all three scripts refuse to run as root
- **Supported distributions:** Ubuntu and Debian
- **Repository location:** Must be cloned to `~/dotfiles`

## Installation Order

Run the scripts in this order:

### 1. Create Symlinks

```bash
./createLinks.sh
```

Creates symlinks from `~/dotfiles` to their system locations (e.g., `~/.config/nvim`,
`~/.config/zsh/.zshrc`).

**What it does:**
- Moves legacy config files (`~/.aliases`, `~/.tmux.conf`, `~/.zshrc`, etc.) to the backup dir
- Creates required directories (`~/.config`, `~/.local`, etc.)
- Symlinks all dotfiles to proper locations
- Moves any existing file it would replace to the backup dir

**Backups:** go to `~/tmp/backup_dots`, mirroring their path under `~`
(`~/.config/zsh/.zshrc` becomes `~/tmp/backup_dots/.config/zsh/.zshrc`). A rerun replaces the
previous backup of the same file.

### 2. Install Packages

```bash
./install-packages.sh
```

Installs all dependencies and development tools.

**What it does:**
- Updates system packages via APT
- Installs Homebrew and brew packages (tmux, eza, fzf, lazygit, etc.)
- Installs Rust/Cargo for Bob neovim manager
- Installs FNM (Fast Node Manager) and Node.js LTS
- Installs global npm packages
- Installs tmux plugin manager and plugins
- Changes default shell to zsh
- If Docker is missing, asks whether to install it (via docker.sh)

**Installation log:** Progress is logged to `~/dotfiles/install_progress_log.txt`

### 3. Docker (Optional)

`install-packages.sh` offers to install Docker if it's not already present. You can also run it
manually:

```bash
./docker.sh
```

**Note:** After Docker installation, log out and back in for group permissions to take effect.

After an Ubuntu release upgrade, rerun `./docker.sh`: the upgrade disables Docker's apt repo, and
the script re-points it at the new release without reinstalling.

## Troubleshooting

- **"Permission denied"**: Make sure scripts are executable (`chmod +x *.sh`)
- **"This script requires sudo access"**: Run with a user that has sudo privileges
- **"dotfiles directory not found"**: Clone the repository to `~/dotfiles`
- **Docker group permissions**: Run `newgrp docker` or log out/in after Docker install
- **Check the log**: Review `~/dotfiles/install_progress_log.txt` for detailed output

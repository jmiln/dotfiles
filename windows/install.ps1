#Requires -RunAsAdministrator

# Utility Functions
function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

function InstallPackageIfNotExist([string]$name, [string]$id) {
    if (!(Test-CommandExists $name)) {
        echo "Installing $name"
        winget install $id -e
        echo "$name installed."
    } else {
        echo "$name is already installed."
    }
}

InstallPackageIfNotExist "git" "Git.Git"
InstallPackageIfNotExist "eza" "eza-community.eza"
InstallPackageIfNotExist "nvim" "Neovim.Neovim"
InstallPackageIfNotExist "Windows Terminal" "Microsoft.WindowsTerminal"
InstallPackageIfNotExist "Powershell 7" "Microsoft.PowerShell"
InstallPackageIfNotExist "fd" "sharkdp.fd"
InstallPackageIfNotExist "7Zip" "7zip.7zip"

# Work out something to confirm each for these:
# AHK, Node, wezterm, winscp, powertoys, gsudo, winscp, vscode
# InstallPackageIfNotExist "Node.js" "OpenJS.NodeJS"
# InstallPackageIfNotExist "Google Chrome" "Google.Chrome"
# InstallPackageIfNotExist "PowerToys" "Microsoft.PowerToys"



# Install normal font (SauceCodeProMono)

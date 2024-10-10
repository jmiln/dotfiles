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

# Programs that aren't always installed, so query for each
$queryPrograms = @{
    "Node.js" = "OpenJS.NodeJS";
    "Google Chrome" = "Google.Chrome";
    "PowerToys" = "Microsoft.PowerToys";
    "Wezterm" = "wez.wezterm";
    "VSCode" = "Microsoft.VisualStudioCode";
    "WinSCP" = "WinSCP.WinSCP";
    "AutoHotKey" = "AutoHotkey.AutoHotkey";

    # Should be replaced by built in sudo as of Win11 24h2?
    # https://github.com/gerardog/gsudo?tab=readme-ov-file#installation
    "GSudo" = "gerardog.gsudo";
}

# Go through the $queryPrograms and check for each before installing
# TODO More usable alternative would be Out-ConsoleGridView
#   - https://github.com/PowerShell/ConsoleGuiTools/tree/main
foreach ($item in $queryPrograms.GetEnumerator()) {
    $Confirm = Read-Host -Prompt "Do you want to install $($item.Key)? (Y/N)"
    if ($confirm -eq 'y') {
        InstallPackageIfNotExist $($item.Key) $($item.Value)
    } else {
        Write-Host "Ignoring $($item.Key)"
    }
}

# Install normal font (SauceCodeProMono)

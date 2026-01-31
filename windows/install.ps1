# Utility Functions
function Test-CommandExists {
    param([string]$command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$ProgressPreference = "SilentlyContinue" # Speeds up downloads by hiding the progress bar
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted -ErrorAction SilentlyContinue

function InstallPackageIfNotExist([string]$name, [string]$id) {
    Write-Host "Checking $name..." -ForegroundColor Cyan
    # winget list returns 0 if found, non-zero if not.
    winget list --id $id --source winget > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Installing $name..." -ForegroundColor Yellow
        winget install --id $id -e --silent --accept-source-agreements --accept-package-agreements --source winget
    } else {
        Write-Host "$name is already installed." -ForegroundColor Green
    }
}

# 4. Improved Module Install (Handles NuGet provider)
function InstallModuleIfNotExist([string]$name) {
    if (-not (Get-Module -ListAvailable -Name $name)) {
        Write-Host "Installing Module: $name" -ForegroundColor Yellow
        Install-Module $name -Force -AllowClobber -Scope CurrentUser
    }
    Import-Module $name
}

function CheckForFont {
    param ( [string]$fontString )
    Add-Type -AssemblyName System.Drawing
    $AllFonts = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
    return [bool]($AllFonts -like "*$fontString*")
}

# Install normal module(s)
$modules = @("posh-git", "PSReadLine", "PSWindowsUpdate", "Microsoft.PowerShell.ConsoleGuiTools", "Microsoft.WinGet.Client")
foreach ($mod in $modules) { InstallModuleIfNotExist $mod }


$defaultPrograms = @{
    "7Zip"             = "7zip.7zip";
    "Powershell 7"     = "Microsoft.PowerShell";
    "Windows Terminal" = "Microsoft.WindowsTerminal";
    "git"              = "Git.Git";

    # NVim / cmd utilities
    "eza"              = "eza-community.eza";   # Cross platform ls alternative
    "fd"               = "sharkdp.fd";          # File/ text finder for Neovim Telescope
    "bat"              = "sharkdp.bat";         # Cat alternative
    "jq"               = "jqlang.jq";           # JSON formatter
    "nvim"             = "Neovim.Neovim";
}
foreach ($item in $defaultPrograms.GetEnumerator()) {
    InstallPackageIfNotExist $item.Key $item.Value
}


# Programs that aren't always installed, so query for each
$queryPrograms = @{
    "Alacritty"     = "Alacritty.Alacritty";
    "AutoHotKey"    = "AutoHotkey.AutoHotkey";
    "Google Chrome" = "Google.Chrome";
    "Node.js"       = "OpenJS.NodeJS";
    "PowerToys"     = "Microsoft.PowerToys";
    "VSCode"        = "Microsoft.VisualStudioCode";
    "Wezterm"       = "wez.wezterm";
    "WinSCP"        = "WinSCP.WinSCP";
    "Python"        = "Python.Python.3.12";
    "Brave"         = "Brave.Brave";

    # LibreOffice / OnlyOffice

    # Should be replaced by built in sudo as of Win11 24H2?
    # https://github.com/gerardog/gsudo?tab=readme-ov-file#installation
    "GSudo" = "gerardog.gsudo";
}

if (Get-Command Out-ConsoleGridView -ErrorAction SilentlyContinue) {
    Write-Host "`nOpening Selection Menu..." -ForegroundColor Magenta
    $selection = $queryPrograms.GetEnumerator() |
                 Select-Object @{N="Name";E={$_.Key}}, @{N="ID";E={$_.Value}} |
                 Out-ConsoleGridView -Title "Select Optional Software" -OutputMode Multiple

    foreach ($app in $selection) {
        InstallPackageIfNotExist $app.Name $app.ID
    }
} else {
    foreach ($item in $queryPrograms.GetEnumerator()) {
        $confirm = Read-Host "Install $($item.Key)? (y/n)"
        if ($confirm -eq "y") { InstallPackageIfNotExist $item.Key $item.Value }
    }
}

if (-not (CheckForFont "SauceCode")) {
    Write-Host "Installing Nerd Fonts..." -ForegroundColor Yellow
    # Using winget for the font is often more reliable than the PSResource module
    winget install "NerdFonts.SourceCodePro" --silent --accept-package-agreements
}

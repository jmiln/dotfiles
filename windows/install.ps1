# Utility Functions
function Test-CommandExists {
    param([string]$command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

function InstallPackageIfNotExist([string]$name, [string]$id) {
    # if (!(Test-CommandExists $name)) {
    if (!(winget list -q --id $id)) {
        echo "Installing $name"
        winget install $id -e --silent
        echo "$name installed."
    } else {
        echo "$name is already installed."
    }
}

function InstallModuleIfNotExist([string]$name) {
    if (-not (Get-Module -ListAvailable -Name $name)) {
        Write-Host "Installing $name"
        Install-Module $name
    }
    Import-Module $name
}

function CheckForFont {
    param ( [string]$fontString )
    $AllFonts = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name;
    $FoundFont = $($AllFonts | Select-String -Pattern ".*${fontString}.*");

    if ($FoundFont) {
        return $true;
    }
    return $false;
}

# Install normal module(s)
InstallModuleIfNotExist PSReadLine
InstallModuleIfNotExist PSWindowsUpdate
InstallModuleIfNotExist Microsoft.PowerShell.ConsoleGuiTools


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
    InstallPackageIfNotExist $($item.Key) $($item.Value)
}


# Programs that aren't always installed, so query for each
$queryPrograms = @{
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

# If we have Out-ConsoleGridView installed & available, use that to let the user choose which programs to install.
# Otherwise, just ask for each as we go
if (Get-Module -Name Microsoft.PowerShell.ConsoleGuiTools) {
    Write-Host ""
    Write-Host "Getting user input of items"
    Write-Host ""
    $programsToInstall = $queryPrograms | Out-ConsoleGridView
    if ($programsToInstall.length -ne 0){
        Write-Host "Installing these programs: ${programsToInstall}"
        foreach ($item in $programsToInstall.GetEnumerator()) {
            InstallPackageIfNotExist $($item.Key) $($item.Value)
        }
    }
} else {
    foreach ($item in $queryPrograms.GetEnumerator()) {
        $Confirm = Read-Host -Prompt "Do you want to install $($item.Key)? (Y/N)"
        if ($confirm -eq 'y') {
            InstallPackageIfNotExist $($item.Key) $($item.Value)
        } else {
            Write-Host "Ignoring $($item.Key)"
        }
    }
}

if (-not (Get-InstalledPSResource -Name "NerdFonts")) {
    Install-PSResource -Name NerdFonts;
}

if (-not (CheckForFont SauceCode) -and (Get-InstalledPSResource -Name "NerdFonts")) {
    Import-Module -Name NerdFonts;
    Install-NerdFont -Name "SourceCodePro" -Scope AllUsers;
}


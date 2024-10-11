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

$defaultPrograms = @{
    "7Zip"             = "7zip.7zip";
    "Powershell 7"     = "Microsoft.PowerShell";
    "Windows Terminal" = "Microsoft.WindowsTerminal";
    "eza"              = "eza-community.eza";
    "fd"               = "sharkdp.fd";
    "git"              = "Git.Git";
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

    # Should be replaced by built in sudo as of Win11 24h2?
    # https://github.com/gerardog/gsudo?tab=readme-ov-file#installation
    "GSudo" = "gerardog.gsudo";
}

# Go through the $queryPrograms and check for each before installing
# TODO More usable alternative would be something like Out-ConsoleGridView so we could just select them then run through all the selections
#   - https://github.com/PowerShell/ConsoleGuiTools/tree/main
foreach ($item in $queryPrograms.GetEnumerator()) {
    $Confirm = Read-Host -Prompt "Do you want to install $($item.Key)? (Y/N)"
    if ($confirm -eq 'y') {
        InstallPackageIfNotExist $($item.Key) $($item.Value)
    } else {
        Write-Host "Ignoring $($item.Key)"
    }
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

if (-not (Get-InstalledPSResource -Name "NerdFonts")) {
    Install-PSResource -Name NerdFonts;
}

if (-not (CheckForFont SauceCode)) {
    Import-Module -Name NerdFonts;
    Install-NerdFont -Name "SourceCodePro" -Scope AllUsers;
}


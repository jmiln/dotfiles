#Requires -RunAsAdministrator

function Set-DotfileLink {
    param (
        [string]$Name,
        [string]$TargetPath,
        [string]$SourcePath,
        [switch]$IsDirectory
    )
    Write-Host "`n--- Linking $Name ---" -ForegroundColor Cyan
    Write-Host "Target: $TargetPath"

    # 1. Check if it exists and backup instead of just deleting
    if (Test-Path $TargetPath) {
        $bakPath = "$TargetPath.bak"
        Write-Host "Existing config found. Moving to $bakPath" -ForegroundColor Gray
        Move-Item $TargetPath $bakPath -Force -ErrorAction SilentlyContinue
    }

    # 2. Ensure parent directory exists
    $parentDir = Split-Path $TargetPath
    if (!(Test-Path $parentDir)) { New-Item -ItemType Directory -Path $parentDir -Force }

    # 3. Create the link
    New-Item -ItemType SymbolicLink -Path $TargetPath -Value $SourcePath -Force
}

# --- Execution ---

# PowerShell Profile (File)
Set-DotfileLink "PowerShell Profile" $profile "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"

# Neovim (Directory)
Set-DotfileLink "Neovim" "$env:USERPROFILE\.config\nvim" "$PSScriptRoot\..\nvim" -IsDirectory

# Alacritty (Directory)
Set-DotfileLink "Alacritty" "$env:APPDATA\alacritty" "$PSScriptRoot\alacritty" -IsDirectory

# Update Environment Variable
$dotfilesPath = (Get-Item "$PSScriptRoot\..").FullName
Write-Host "`nSetting DOTFILES env var to: $dotfilesPath" -ForegroundColor Green
[Environment]::SetEnvironmentVariable("DOTFILES", $dotfilesPath, "User")

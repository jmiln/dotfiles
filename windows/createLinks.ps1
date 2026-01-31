#Requires -RunAsAdministrator

function Set-DotfileLink {
    param (
        [string]$Name,
        [string]$TargetPath,
        [string]$SourcePath,
        [switch]$IsDirectory
    )

    # Convert to absolute paths to prevent broken links
    $SourcePath = (Get-Item $SourcePath).FullName

    Write-Host "`n--- Linking $Name ---" -ForegroundColor Cyan
    Write-Host "Target: $TargetPath"

    # 1. Check if the link already exists and is correct
    if (Test-Path $TargetPath) {
        $existingLink = Get-Item $TargetPath
        if ($existingLink.LinkType -and $existingLink.Target -eq $SourcePath) {
            Write-Host "Correct link already exists. Skipping." -ForegroundColor Green
            return
        }

        # 2. Backup existing file/folder if it's not the correct link
        $bakPath = "$TargetPath.bak"
        Write-Host "Existing config found. Moving to $bakPath" -ForegroundColor Gray
        # Handle case where .bak already exists
        if (Test-Path $bakPath) { Remove-Item $bakPath -Recurse -Force }
        Move-Item $TargetPath $bakPath -Force
    }

    # 3. Ensure parent directory exists
    $parentDir = Split-Path $TargetPath
    if (!(Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # 4. Create the link
    # Using Junction for Directories (more native to Windows) and Symlink for Files
    $linkType = if ($IsDirectory) { "Junction" } else { "SymbolicLink" }

    New-Item -ItemType $linkType -Path $TargetPath -Value $SourcePath -Force | Out-Null
    Write-Host "Successfully linked!" -ForegroundColor Green
}

# --- Execution ---

# PowerShell Profile (File)
Set-DotfileLink "PowerShell Profile" $profile.CurrentUserAllHosts "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"

# Neovim (Directory)
Set-DotfileLink "Neovim" "$env:USERPROFILE\.config\nvim" "$PSScriptRoot\..\nvim" -IsDirectory

# Alacritty (Directory)
Set-DotfileLink "Alacritty" "$env:APPDATA\alacritty" "$PSScriptRoot\..\alacritty" -IsDirectory

# Update Environment Variable
$dotfilesPath = (Get-Item "$PSScriptRoot\..").FullName
Write-Host "`nSetting DOTFILES env var to: $dotfilesPath" -ForegroundColor Green
[Environment]::SetEnvironmentVariable("DOTFILES", $dotfilesPath, "User")

# Refresh the current session's variable so the profile can use it immediately
$env:DOTFILES = $dotfilesPath

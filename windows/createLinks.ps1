Write-Host "Deleting the old profile then linking to this one"
Write-Host "> $profile"
rm $profile
cmd /c mklink $profile "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"

Write-Host ""
Write-Host "Deleting the old nvim dir then linking to this one"
$nvimDir = "$env:LOCALAPPDATA\nvim"
Write-Host "> $nvimDir"
rm $nvimDir -ErrorAction SilentlyContinue -Recurse
cmd /c mklink /d $nvimDir "$PSScriptRoot\..\nvim"

Write-Host ""
Write-Host "Deleting the old wezterm dir then linking to this one"
$wezDir = "$env:USERPROFILE\.config\wezterm"
Write-Host "> $wezDir"
rm $wezDir -ErrorAction SilentlyContinue
cmd /c mklink /d $wezDir "$PSScriptRoot\wezterm"

Write-Host ""
Write-Host "Setting env:DOTFILES Environment Variable"
$dotfilesPath = Join-Path -Path $PSScriptRoot -ChildPath ".." -Resolve
Write-Host "> $dotfilesPath"
Set-ItemProperty "HKCU:\Environment" "DOTFILES" $dotfilesPath -Type ExpandString

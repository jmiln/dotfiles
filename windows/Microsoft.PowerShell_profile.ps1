# https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
Import-Module PSReadLine

Set-PSReadlineOption -EditMode Emacs

# History search for up/down arrows
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Bash-style tab complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Quick alias for git status
function gits {git status}

# Make it so ctrl+d will close the terminal if in an empty prompt
Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit

# Utility Functions
function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

# Editor Configs
$EDITOR = if (Test-CommandExists nvim) { 'nvim' }
      elseif (Test-CommandExists pvim) { 'pvim' }
      elseif (Test-CommandExists vim)  { 'vim' }
      elseif (Test-CommandExists vi)   { 'vi' }
      elseif (Test-CommandExists code) { 'code' }
      elseif (Test-CommandExists notepad++) { 'notepad++' }
      else { 'notepad' }
Set-Alias -Name vim -Value $EDITOR

# Enhanced Listing
if (Test-CommandExists eza) {
    rm alias:ls -ErrorAction SilentlyContinue
    function ls {eza.exe @args}
    function la {ls -a @args}
    function ll {ls -l @args}
    function lla {ls -la @args}
} elseif ($host.Name -eq 'ConsoleHost' && Test-CommandExists git) {
    function ls_git { & 'C:\Program Files\Git\usr\bin\ls' --color=auto -hF $args }
    Set-Alias -Name ls -Value ls_git -Option Private
    function la {ls_git -a}
    function ll {ls_git -l}
    function lla {ls_git -la}
} else {
    function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
    function ll { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }
}
Set-Alias -Name l -Value ls

# Quick CD back up the file tree
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# Navigation Shortcuts
function dt   { Set-Location ~\Desktop }
function docs { Set-Location ~\Documents }
function dl   { Set-Location ~\Downloads }

# Basic commands
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }






# Initial GitHub.com connectivity check with 1 second timeout
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

function Update-PowerShell {
    if (-not $global:canConnectToGitHub) {
        Write-Host "Skipping PowerShell update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
        return
    }

    try {
        Write-Host "Checking for PowerShell updates..." -ForegroundColor Cyan
        $updateNeeded = $false
        $currentVersion = $PSVersionTable.PSVersion.ToString()
        $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
        $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
        $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
        if ($currentVersion -lt $latestVersion) {
            $updateNeeded = $true
        }

        if ($updateNeeded) {
            Write-Host "Updating PowerShell..." -ForegroundColor Yellow
            winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements
            Write-Host "PowerShell has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
        } else {
            Write-Host "Your PowerShell is up to date." -ForegroundColor Green
        }
    } catch {
        Write-Error "Failed to update PowerShell. Error: $_"
    }
}
Update-PowerShell

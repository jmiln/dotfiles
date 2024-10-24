# https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
Import-Module PSReadLine

# This import lets me use the `sudo` command wherever needed
# https://github.com/gerardog/gsudo
# winget install gerardog.gsudo
Import-Module gsudoModule

Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineOption -BellStyle "None";

# History search for up/down arrows
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Ctrl+right/left arrow to move between words easily
Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord

Set-PSReadLineKeyHandler -Chord "Ctrl+a" -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord "Ctrl+e" -Function EndOfLine

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
    # If we've installed eza, use that
    rm alias:ls -ErrorAction SilentlyContinue
    function ls  {eza.exe --time-style=long-iso --group-directories-first @args}
    function la  {ls -a @args}
    function ll  {ls -l @args}
    function lla {ls -la @args}
    function lt  {ls -l --tree @args}
} elseif ($host.Name -eq 'ConsoleHost' && Test-CommandExists git) {
    # Else, if Git is installed, use the ls from git-bash
    function ls_git { & 'C:\Program Files\Git\usr\bin\ls' --color=auto -hF $args }
    Set-Alias -Name ls -Value ls_git -Option Private
    function la {ls_git -a @args}
    function ll {ls_git -l @args}
    function lla {ls_git -la @args}
} else {
    # Then if we really need to, use the basic powershell commands
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
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue }
function touch($file) { "" | Out-File $file -Encoding ASCII }


function prompt {
    # Get up to the last 2 directories
    $path = $pwd.Path
    $path = $path.Replace($env:USERPROFILE, '~')
    $path = $path.Split('\') | Select-Object -Last 2
    $path = $path -join "\"

    # Test for Admin / Elevated
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    # Put together & color the prompt itself
    Write-host "${env:USERNAME}" -NoNewline -ForegroundColor Green
    Write-host "@" -NoNewline -ForegroundColor Blue
    Write-host "${env:COMPUTERNAME}:" -NoNewline -ForegroundColor White
    Write-host "${path}" -NoNewline -ForegroundColor Blue
    Write-host ($(if ($IsAdmin) { ' [Admin]' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    " $ "
}



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

function dotfiles () {
    cd $env:DOTFILES;
}

# Set up autocomplete for winget
# via: https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

function psUpdate() {
    Update-PowerShell
}

function Update-System() {
    Install-WindowsUpdate -IgnoreUserInput -IgnoreReboot -AcceptAll
    winget update --all
    Update-Module
    Update-Help -Force
    if ((which npm)) {
        npm i -g npm
        npm update -g
    }
}

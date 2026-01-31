# https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
Import-Module PSReadLine
Import-Module posh-git

Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineOption -BellStyle "None";

# History search for up/down arrows
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# This adds the "shadow text" suggestions based on your history
if ($PSVersionTable.PSVersion.Major -ge 7) {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView
}

# Ctrl+right/left arrow to move between words easily
Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord

Set-PSReadLineKeyHandler -Chord "Ctrl+a" -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord "Ctrl+e" -Function EndOfLine

# Bash-style tab complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Make it so ctrl+d will close the terminal if in an empty prompt
Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit

# Utility Functions
function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

# Editor Configs
$DefaultEditor = (Get-Command nvim, vim, code, notepad++ -ErrorAction SilentlyContinue | Select-Object -First 1).Source
if (-not $DefaultEditor) { $DefaultEditor = "notepad.exe" }
$env:EDITOR = $DefaultEditor
Set-Alias -Name vim -Value $DefaultEditor

# Enhanced Listing
if (Test-CommandExists eza) {
    if (Get-Alias ls -ErrorAction SilentlyContinue) { Remove-Item alias:ls }
    function ls { eza.exe --time-style=long-iso --group-directories-first $args }
    function l  { ls $args }
    function la { ls -a $args }
    function ll { ls -lh --git --icons=always $args }
    function lla { ll -a $args }
    function lt { ls --icons=always --tree --ignore-glob "node_modules" $args }
    function llt   {lt -l $args}
    function llta  {lt -la $args}
} elseif (Test-CommandExists git -And $host.Name -eq 'ConsoleHost') {
    $gitLs = "$env:ProgramFiles\Git\usr\bin\ls.exe"
    function ls { & $gitLs --color=auto -hF $args }
    function la { & $gitLs --color=auto -hFa $args }
    function ll { & $gitLs --color=auto -hFl $args }
} else {
    function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
    function ll { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
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
function dotfiles { Set-Location $env:DOTFILES }

# Basic commands
function gits {git status}
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue }
function touch {
    param([Parameter(Mandatory=$true)]$Path)
    New-Item -ItemType File -Path $Path -Force | Out-Null
}

function prompt {
    $path = $pwd.Path.Replace($env:USERPROFILE, '~')
    # Better path splitting that handles root directories (C:\) safely
    $parts = $path.Split('\')
    $displayPath = if ($parts.Length -gt 2) { $parts[-2..-1] -join "\" } else { $path }

    $IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    Write-host "${env:USERNAME}" -NoNewline -ForegroundColor Green
    Write-host "@" -NoNewline -ForegroundColor Blue
    Write-host "${env:COMPUTERNAME}:" -NoNewline -ForegroundColor White
    Write-host "${displayPath}" -NoNewline -ForegroundColor Blue

    # Git branch / status
    $gitStatus = Get-GitStatus -ErrorAction SilentlyContinue
    if ($gitStatus) {
        $symbols = ""

        if ($gitStatus.AheadBy -gt 0)  { $symbols += "↑" }
        if ($gitStatus.BehindBy -gt 0) { $symbols += "↓" }
        if ($gitStatus.HasWorking -or $gitStatus.HasUntracked) {
            $symbols += "●"
        }
        if ($gitStatus.HasIndex)       { $symbols += "+" } # staged

        if ($symbols) {
            Write-Host " [$symbols]" -NoNewline -ForegroundColor Yellow
        }

        Write-Host " [$($gitStatus.Branch)]" -NoNewline -ForegroundColor Cyan
    }

    # Admin check
    if ($IsAdmin) {
        Write-host " [Admin]" -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    }
    " $ "
}

function Update-PowerShell {
    Write-Host "Checking for PowerShell updates..." -ForegroundColor Cyan
    try {
        $currentVersion = $PSVersionTable.PSVersion.ToString()
        $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" -TimeoutSec 2
        $latestVersion = $latestRelease.tag_name.Trim('v')

        if ($currentVersion -lt $latestVersion) {
            Write-Host "Updating PowerShell to $latestVersion..." -ForegroundColor Yellow
            winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements
        } else {
            Write-Host "PowerShell is up to date." -ForegroundColor Green
        }
    } catch {
        Write-Warning "Could not check for updates (Check your internet connection)."
    }
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

function Update-System {
    Write-Host "Updating System Packages..." -ForegroundColor Cyan
    winget update --all --accept-source-agreements
    Update-Module -Name * -ErrorAction SilentlyContinue
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Host "Updating NPM..." -ForegroundColor Yellow
        npm i -g npm
        if (Get-Command ncu -ErrorAction SilentlyContinue) {
            Write-Host "Updating global npm packages..." -ForegroundColor Yellow
            ncu -g --upgrade
        }
    }
}


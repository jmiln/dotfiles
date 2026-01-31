#Requires -RunAsAdministrator

# Via https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1

function Set-RegKey {
    param (
        [string]$Path,
        [string]$Name,
        $Value,
        [string]$Type = "DWord"
    )
    if (!(Test-Path $Path)) { New-Item -Path $path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
}

###############################################################################
### Privacy                                                                   #
###############################################################################

Write-Host "Configuring Privacy & Disabling Web Search..." -ForegroundColor Yellow

$PrivacyKeys = @{
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" = @{ "Enabled" = 0 }
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" = @{ "Start-TrackProgs" = 0 }
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" = @{ "EnableWebContentEvaluation" = 0 }
    "HKCU:\SOFTWARE\Microsoft\Input\TIPC" = @{ "Enabled" = 0 }
    "HKCU:\Control Panel\International\User Profile" = @{ "HttpAcceptLanguageOptOut" = 1 }
    "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" = @{ "NumberOfSIUFInPeriod" = 0 } # No feedback prompts
}

# Apply simple Key/Value pairs
foreach ($path in $PrivacyKeys.Keys) {
    if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
    $PrivacyKeys[$path].GetEnumerator() | ForEach-Object {
        Set-ItemProperty -Path $path -Name $_.Key -Value $_.Value
    }
}

# General: Disable suggested content in settings app: Enable: 1, Disable: 0
$CDM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
Set-RegKey $CDM "SubscribedContent-338393Enabled" 0
Set-RegKey $CDM "SubscribedContent-338394Enabled" 0
Set-RegKey $CDM "SubscribedContent-338396Enabled" 0

# General: Disable tips and suggestions for welcome and what's new: Enable: 1, Disable: 0
Set-RegKey $CDM "SubscribedContent-310093Enabled" 0

# General: Disable tips and suggestions when I use windows: Enable: 1, Disable: 0
Set-RegKey $CDM "SubscribedContent-338389Enabled" 0

# Start Menu: Disable search entries: Enable: 0, Disable: 1
# --- KILL START MENU WEB SEARCH (Bing) ---
$SearchPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
Set-RegKey $SearchPath "DisableSearchBoxSuggestions" 1

$BingPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
Set-RegKey $BingPath "BingSearchEnabled" 0
Set-RegKey $BingPath "CortanaConsent" 0

# Privacy: Default App Permissions (Deny by default)
$ConsentStore = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore"
@(
    "appDiagnostics"
    "appointments",
    "bluetoothSync",
    "broadFileSystemAccess",
    "chat",
    "contacts",
    "documentsLibrary",
    "downloadsFolder",
    "email",
    "graphicsCaptureProgrammatic",
    "graphicsCaptureWithoutBorder",
    "location",
    "location",
    "microphone",
    "musicLibrary",
    "phoneCall",
    "phoneCallHistory",
    "picturesLibrary",
    "radios",
    "userAccountInformation",
    "userDataTasks",
    "userNotificationListener",
    "videosLibrary",
    "webcam"
) | ForEach-Object {
    Set-RegKey "$ConsentStore\$_" "Value" "Deny" -Type String
}

# Speech, Inking, & Typing: Stop "Getting to know me"
Set-RegKey "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1
Set-RegKey "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1
Set-RegKey "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" 0
Set-RegKey "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0
Set-RegKey "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0

# Feedback: Telemetry: Send Diagnostic and usage data: Basic: 1, Enhanced: 2, Full: 3
Set-RegKey "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 1
Set-RegKey "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "MaxTelemetryAllowed" 1


###############################################################################
### Devices, Power, and Startup                                               #
###############################################################################
Write-Host "Configuring Devices, Power, and Startup..." -ForegroundColor "Yellow"

# Sound: Disable Startup Sound: Enable: 0, Disable: 1
Set-RegKey "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DisableStartupSound" 1
Set-RegKey "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" "DisableStartupSound" 1
Set-RegKey "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\EditionOverrides" "UserSetting_DisableStartupSound" 1

# Power: Disable Hibernation
powercfg /hibernate off


###############################################################################
### Explorer, Taskbar, and System Tray                                        #
###############################################################################
Write-Host "Configuring Explorer, Taskbar, and System Tray..." -ForegroundColor "Yellow"

# Enable Dark Mode
$ThemePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Set-RegKey $ThemePath -Name "SystemUsesLightTheme" -Value 0
Set-RegKey $ThemePath -Name "AppsUseLightTheme" -Value 0

# Explorer: Show hidden files by default: Show Files: 1, Hide Files: 2
$ExplorerPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-RegKey $ExplorerPath "Hidden" 1

# Explorer: Show file extensions by default: Hide: 1, Show: 0
Set-RegKey $ExplorerPath "HideFileExt" 0

# Explorer: Show path in title bar: Hide: 0, Show: 1
$CabPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState"
Set-RegKey $CabPath "FullPath" 1

# Explorer: Disable creating Thumbs.db files on network volumes: Enable: 0, Disable: 1
Set-RegKey "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1

# Taskbar: Hide the Search, Task, Widget, and Chat buttons: Show: 1, Hide: 0
Set-RegKey "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0  # Search

# Taskbar: Don't show Windows Store Apps on Taskbar
Set-RegKey $ExplorerPath "ShowTaskViewButton" 0
Set-RegKey $ExplorerPath "TaskbarDa" 0 # Widgets
Set-RegKey $ExplorerPath "TaskbarMn" 0 # Chat


###############################################################################
### Default Windows Applications                                              #
###############################################################################
Write-Host "Configuring Default Windows Applications..." -ForegroundColor "Yellow"

Write-Host "Remove standard applications:"
Write-Host " - Apps"

# Apps

# Kill OneDrive completely
Write-Host " - Removing OneDrive" -ForegroundColor Gray
taskkill /f /im OneDrive.exe 2>$null
$oneDriveUninstaller = if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") { "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" } else { "$env:SystemRoot\System32\OneDriveSetup.exe" }
Start-Process $oneDriveUninstaller "/uninstall" -NoNewWindow -Wait 2>$null


Write-Host " - Packages"
# List currently installed ones with: Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -Like "*Microsoft.*" }

$packages = @(
    "*.AutodeskSketchBook*"                                # Uninstall Autodesk Sketchbook
    "*.DisneyMagicKingdoms*"                               # Uninstall Disney Magic Kingdoms
    "*.MarchofEmpires*"                                    # Uninstall March of Empires
    "*.SlingTV*"                                           # Uninstall SlingTV
    "*.TikTok*"                                            # Uninstall TikTok
    "*.Twitter*"                                           # Uninstall Twitter
    "*AdobeSystemsIncorporated.AdobeCreativeCloudExpress*" # Uninstall Adobe Creative Cloud Express
    "*AmazonVideo.PrimeVideo*"                             # Uninstall Amazon Prime Video
    "*Clipchamp.Clipchamp*"                                # Uninstall ClipChamp Video Editor
    "*Disney.37853FC22B2CE*"                               # Uninstall Disney+
    "*DolbyLaboratories.DolbyAccess*"                      # Uninstall Dolby
    "*Facebook.Facebook*"                                  # Uninstall Facebook
    "*Facebook.Instagram*"                                 # Uninstall Instagram
    "*Microsoft.3DBuilder*"                                # Uninstall 3D Builder
    "*Microsoft.549981C3F5F10*"                            # Uninstall Cortana
    "*Microsoft.BingFinance*"                              # Uninstall Bing Finance
    "*Microsoft.BingNews*"                                 # Uninstall Bing News
    "*Microsoft.BingSports*"                               # Uninstall Bing Sports
    "*Microsoft.BingWeather*"                              # Uninstall Bing Weather
    # "*Microsoft.GamingApp*"
    "*Microsoft.GetHelp*"
    "*Microsoft.Getstarted*"
    "*Microsoft.Messaging*"                                # Uninstall Messaging
    "*Microsoft.MicrosoftOfficeHub*"                       # Uninstall Get Office, and it's "Get Office365" notifications
    "*Microsoft.MicrosoftSolitaireCollection*"             # Uninstall Solitaire
    "*Microsoft.MicrosoftStickyNotes*"                     # Uninstall StickyNotes
    "*Microsoft.MixedReality.Portal*"
    "*Microsoft.Office.OneNote*"                           # Uninstall OneNote
    "*Microsoft.Office.Sway*"                              # Uninstall Sway
    "*Microsoft.OneConnect*"                               # Uninstall Mobile Plans
    "*Microsoft.OneDriveSync*"
    "*Microsoft.People*"                                   # Uninstall People
    "*Microsoft.PowerAutomateDesktop*"
    "*Microsoft.Print3D*"                                  # Uninstall Print3D
    "*Microsoft.SkypeApp*"                                 # Uninstall Skype
    "*Microsoft.ToDos*"                                    # Uninstall Microsoft ToDos
    "*Microsoft.Todos*"
    "*Microsoft.Windows.Photos*"                           # Uninstall Photos
    "*Microsoft.WindowsAlarms*"                            # Uninstall Alarms and Clock
    "*Microsoft.WindowsCommunicationsApps*"                # Uninstall Calendar and Mail
    "*Microsoft.WindowsFeedbackHub*"
    "*Microsoft.WindowsMaps*"                              # Uninstall Maps
    "*Microsoft.WindowsSoundRecorder*"                     # Uninstall Voice Recorder
    # "*Microsoft.Xbox.TCUI*"
    # "*Microsoft.XboxApp*"
    "*Microsoft.YourPhone*"                                # Uninstall Your Phone
    "*Microsoft.ZuneMusic*"                                # Uninstall Zune Music (Groove)
    "*Microsoft.ZuneVideo*"                                # Uninstall Zune Video
    "*MicrosoftTeams*"
    "*MicrosoftWindows.Client.WebExperience*"
    "*SpotifyAB.SpotifyMusic*"                             # Uninstall Spotify
    "*king.com.BubbleWitch3Saga*"                          # Uninstall Bubble Witch 3 Saga
    "*king.com.CandyCrushSodaSaga*"                        # Uninstall Candy Crush Soda Saga
    "*microsoft.windowscommunicationsapps*"
)
foreach ($pkg in $packages) {
    # Remove from current user and future new users (Provisioned)
    Get-AppxPackage -AllUsers $pkg -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -Like $pkg } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}


# Capabilities
# List currently installed ones with: Get-WindowsCapability -Online | Where-Object { $_.State -Like "Installed" }

# foreach ($capability in @(
#     # List here if any
# ))
# {
# 	Remove-WindowsCapability -Online -Name $capability | Out-Null
# }



###############################################################################
### Accessibility and Ease of Use                                             #
###############################################################################
Write-Host "Configuring Accessibility..." -ForegroundColor "Yellow"

# Turn Off Windows Narrator Hotkey: Enable: 1, Disable: 0
Set-RegKey "HKCU:\SOFTWARE\Microsoft\Narrator\NoRoam" "WinEnterLaunchEnabled" 0

# Disable "Window Snap" Automatic Window Arrangement: Enable: 1, Disable: 0
Set-RegKey "HKCU:\Control Panel\Desktop" "WindowArrangementActive" 1

# Disable automatic fill to space on Window Snap: Enable: 1, Disable: 0
Set-RegKey "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapFill" 0

# Disable showing what can be snapped next to a window: Enable: 1, Disable: 0
Set-RegKey "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapAssist" 0

# Disable automatic resize of adjacent windows on snap: Enable: 1, Disable: 0
Set-RegKey "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "JointResize" 0

###############################################################################
### Windows Update & Application Updates                                      #
###############################################################################

Write-Host "Configuring Windows Update..." -ForegroundColor "Yellow"

# Ensure Windows Update registry paths
# Disable automatic reboot after install: Enable: 1, Disable: 0
Set-RegKey "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "IsExpedited" 0
Set-RegKey "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" "NoAutoRebootWithLoggedOnUsers" 1
Set-RegKey "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoRebootWithLoggedOnUsers" 1

# Disable restart required notifications: Enable: 1, Disable: 0
Set-RegKey "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "RestartNotificationsAllowed2" 0

# Disable updates over metered connections: Enable: 1, Disable: 0
Set-RegKey "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "AllowAutoWindowsUpdateDownloadOverMeteredNetwork" 0

# Configure to Auto-Download but not Install: NotConfigured: 0, Disabled: 1, NotifyBeforeDownload: 2, NotifyBeforeInstall: 3, ScheduledInstall: 4
Set-RegKey "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 3

# Include Recommended Updates
Set-RegKey "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "IncludeRecommendedUpdates" 1




#Requires -RunAsAdministrator

# Via https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1

###############################################################################
### Privacy                                                                   #
###############################################################################

Write-Host "Configuring Privacy..." -ForegroundColor "Yellow"

# General: Don't let apps use advertising ID for experiences across apps: Allow: 1, Disallow: 0
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0
Remove-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Id" -ErrorAction SilentlyContinue

# General: Disable Application launch tracking: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start-TrackProgs" 0

# General: Disable SmartScreen Filter for Store Apps: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" "EnableWebContentEvaluation" 0

# General: Disable key logging & transmission to Microsoft: Enable: 1, Disable: 0
# Disabled when Telemetry is set to Basic
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0

# General: Opt-out from websites from accessing language list: Opt-in: 0, Opt-out 1
Set-ItemProperty "HKCU:\Control Panel\International\User Profile" "HttpAcceptLanguageOptOut" 1

# General: Disable suggested content in settings app: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338394Enabled" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338396Enabled" 0

# General: Disable tips and suggestions for welcome and what's new: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" 0

# General: Disable tips and suggestions when I use windows: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" 0

# Start Menu: Disable search entries: Enable: 0, Disable: 1
if (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer")) {New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\Software\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" 1

# Camera: Don't let apps use camera: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" "Value" "Deny"

# Microphone: Don't let apps use microphone: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" "Value" "Deny"

# Notifications: Don't let apps access notifications: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" "Value" "Deny"

# Speech, Inking, & Typing: Stop "Getting to know me"
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" 0
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0

# Account Info: Don't let apps access name, picture, and other account info: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" "Value" "Deny"

# Contacts: Don't let apps access contacts: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" "Value" "Deny"

# Calendar: Don't let apps access calendar: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" "Value" "Deny"

# Call History: Don't let apps make phone calls: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" "Value" "Deny"

# Call History: Don't let apps access call history: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" "Value" "Deny"

# Diagnostics: Don't let apps access diagnostics of other apps: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" "Value" "Deny"

# Documents: Don't let apps access documents: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny"

# Downloads: Don't let apps access downloads: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder" "Value" "Deny"

# Email: Don't let apps read and send email: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" "Value" "Deny"

# File System: Don't let apps access the file system: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" "Value" "Deny"

# Location: Don't let apps access the location: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny"

# Messaging: Don't let apps read or send messages (text or MMS): Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" "Value" "Deny"

# Music Library: Don't let apps access music library: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary" "Value" "Deny"

# Pictures: Don't let apps access pictures: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny"

# Radios: Don't let apps control radios (like Bluetooth): Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" "Value" "Deny"

# Screenshot: Don't let apps take screenshots: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic" "Value" "Deny"

# Screenshot Borders: Don't let apps access screenshot border settings: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder" "Value" "Deny"

# Tasks: Don't let apps access the tasks: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" "Value" "Deny"

# Other Devices: Don't let apps share and sync with non-explicitly-paired wireless devices over uPnP: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" "Value" "Deny"

# Videos: Don't let apps access videos: Allow, Deny
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny"

# Feedback: Windows should never ask for my feedback
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0

# Feedback: Telemetry: Send Diagnostic and usage data: Basic: 1, Enhanced: 2, Full: 3
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "MaxTelemetryAllowed" 1



###############################################################################
### Devices, Power, and Startup                                               #
###############################################################################
Write-Host "Configuring Devices, Power, and Startup..." -ForegroundColor "Yellow"

# Sound: Disable Startup Sound: Enable: 0, Disable: 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\EditionOverrides" "UserSetting_DisableStartupSound" 1

# Power: Disable Hibernation
powercfg /hibernate off


###############################################################################
### Explorer, Taskbar, and System Tray                                        #
###############################################################################
Write-Host "Configuring Explorer, Taskbar, and System Tray..." -ForegroundColor "Yellow"

# Prerequisite: Ensure necessary registry paths
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Type Folder | Out-Null}
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Type Folder | Out-Null}

# Explorer: Show hidden files by default: Show Files: 1, Hide Files: 2
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# Explorer: Show file extensions by default: Hide: 1, Show: 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# Explorer: Show path in title bar: Hide: 0, Show: 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1

# Explorer: Disable creating Thumbs.db files on network volumes: Enable: 0, Disable: 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1

# Taskbar: Hide the Search, Task, Widget, and Chat buttons: Show: 1, Hide: 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0  # Search
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" 0 # Task
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" 0 # Widgets
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" 0 # Chat

# Taskbar: Don't show Windows Store Apps on Taskbar
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "StoreAppsOnTaskbar" 0

# Taskbar: Show colors on Taskbar, Start, and SysTray: Disabled: 0, Taskbar, Start, & SysTray: 1, Taskbar Only: 2
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "ColorPrevalence" 1

# Titlebar: Disable theme colors on titlebar: Enable: 1, Disable: 0
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\DWM" "ColorPrevalence" 0

# Recycle Bin: Disable Delete Confirmation Dialog: Enable: 1, Disable: 0
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ConfirmFileDelete" 0



###############################################################################
### Default Windows Applications                                              #
###############################################################################
Write-Host "Configuring Default Windows Applications..." -ForegroundColor "Yellow"

# Uninstall 3D Builder
Get-AppxPackage "Microsoft.3DBuilder" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.3DBuilder" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Adobe Creative Cloud Express
Get-AppxPackage "AdobeSystemsIncorporated.AdobeCreativeCloudExpress" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "AdobeSystemsIncorporated.AdobeCreativeCloudExpress" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Alarms and Clock
Get-AppxPackage "Microsoft.WindowsAlarms" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.WindowsAlarms" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Amazon Prime Video
Get-AppxPackage "AmazonVideo.PrimeVideo" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "AmazonVideo.PrimeVideo" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Autodesk Sketchbook
Get-AppxPackage "*.AutodeskSketchBook" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.AutodeskSketchBook" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Bing Finance
Get-AppxPackage "Microsoft.BingFinance" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.BingFinance" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Bing News
Get-AppxPackage "Microsoft.BingNews" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.BingNews" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Bing Sports
Get-AppxPackage "Microsoft.BingSports" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.BingSports" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Bing Weather
Get-AppxPackage "Microsoft.BingWeather" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.BingWeather" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Bubble Witch 3 Saga
Get-AppxPackage "king.com.BubbleWitch3Saga" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "king.com.BubbleWitch3Saga" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Calendar and Mail
Get-AppxPackage "Microsoft.WindowsCommunicationsApps" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.WindowsCommunicationsApps" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Candy Crush Soda Saga
Get-AppxPackage "king.com.CandyCrushSodaSaga" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "king.com.CandyCrushSodaSaga" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall ClipChamp Video Editor
Get-AppxPackage "Clipchamp.Clipchamp" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Clipchamp.Clipchamp" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Cortana
Get-AppxPackage "Microsoft.549981C3F5F10" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.549981C3F5F10" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Disney+
Get-AppxPackage "Disney.37853FC22B2CE" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Disney.37853FC22B2CE" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Disney Magic Kingdoms
Get-AppxPackage "*.DisneyMagicKingdoms" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.DisneyMagicKingdoms" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Dolby
Get-AppxPackage "DolbyLaboratories.DolbyAccess" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "DolbyLaboratories.DolbyAccess" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Facebook
Get-AppxPackage "Facebook.Facebook*" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Facebook.Facebook*" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Get Office, and it's "Get Office365" notifications
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.MicrosoftOfficeHub" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Instagram
Get-AppxPackage "Facebook.Instagram*" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Facebook.Instagram*" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Maps
Get-AppxPackage "Microsoft.WindowsMaps" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.WindowsMaps" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall March of Empires
Get-AppxPackage "*.MarchofEmpires" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.MarchofEmpires" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Messaging
Get-AppxPackage "Microsoft.Messaging" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Messaging" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Mobile Plans
Get-AppxPackage "Microsoft.OneConnect" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.OneConnect" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall OneNote
Get-AppxPackage "Microsoft.Office.OneNote" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Office.OneNote" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall People
Get-AppxPackage "Microsoft.People" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.People" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Photos
Get-AppxPackage "Microsoft.Windows.Photos" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Windows.Photos" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Print3D
Get-AppxPackage "Microsoft.Print3D" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Print3D" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Skype
Get-AppxPackage "Microsoft.SkypeApp" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.SkypeApp" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall SlingTV
Get-AppxPackage "*.SlingTV" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.SlingTV" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Solitaire
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Spotify
Get-AppxPackage "SpotifyAB.SpotifyMusic" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "SpotifyAB.SpotifyMusic" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall StickyNotes
Get-AppxPackage "Microsoft.MicrosoftStickyNotes" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.MicrosoftStickyNotes" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Sway
Get-AppxPackage "Microsoft.Office.Sway" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.Office.Sway" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall TikTok
Get-AppxPackage "*.TikTok" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.TikTok" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Microsoft ToDos
Get-AppxPackage "Microsoft.ToDos" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.ToDos" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Twitter
Get-AppxPackage "*.Twitter" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "*.Twitter" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Voice Recorder
Get-AppxPackage "Microsoft.WindowsSoundRecorder" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.WindowsSoundRecorder" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Your Phone
Get-AppxPackage "Microsoft.YourPhone" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.YourPhone" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Zune Music (Groove)
Get-AppxPackage "Microsoft.ZuneMusic" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.ZuneMusic" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null

# Uninstall Zune Video
Get-AppxPackage "Microsoft.ZuneVideo" -AllUsers | Remove-AppxPackage -AllUsers
Get-AppXProvisionedPackage -Online | Where DisplayName -like "Microsoft.ZuneVideo" | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null



###############################################################################
### Accessibility and Ease of Use                                             #
###############################################################################
Write-Host "Configuring Accessibility..." -ForegroundColor "Yellow"

# Turn Off Windows Narrator Hotkey: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Narrator\NoRoam" "WinEnterLaunchEnabled" 0

# Disable "Window Snap" Automatic Window Arrangement: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\Control Panel\Desktop" "WindowArrangementActive" 1

# Disable automatic fill to space on Window Snap: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapFill" 0

# Disable showing what can be snapped next to a window: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapAssist" 0

# Disable automatic resize of adjacent windows on snap: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "JointResize" 0


###############################################################################
### Windows Update & Application Updates                                      #
###############################################################################
Write-Host "Configuring Windows Update..." -ForegroundColor "Yellow"

# Ensure Windows Update registry paths
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Type Folder | Out-Null }
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Type Folder | Out-Null }

# Disable automatic reboot after install: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "IsExpedited" 0
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" "NoAutoRebootWithLoggedOnUsers" 1
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoRebootWithLoggedOnUsers" 1

# Disable restart required notifications: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "RestartNotificationsAllowed2" 0

# Disable updates over metered connections: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "AllowAutoWindowsUpdateDownloadOverMeteredNetwork" 0

# Configure to Auto-Download but not Install: NotConfigured: 0, Disabled: 1, NotifyBeforeDownload: 2, NotifyBeforeInstall: 3, ScheduledInstall: 4
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 3

# Include Recommended Updates
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "IncludeRecommendedUpdates" 1




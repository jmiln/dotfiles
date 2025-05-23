#Requires -RunAsAdministrator

# Found from
# https://github.com/JMOrbegoso/Dotfiles-for-Windows-11/blob/main/src/Windows/Windows.ps1

function Set-WindowsExplorer-ShowFileExtensions {
  Write-Host "Configuring Windows File Explorer to show file extensions:" -ForegroundColor "Green";

  $RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
  Set-ItemProperty -Path $RegPath -Name "HideFileExt" -Value 0;
}

function Set-WindowsFileExplorer-StartFolder {
  Write-Host "Configuring start folder of Windows File Explorer:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";

  if (-not (Test-Path -Path $RegPath -Name "LaunchTo")) {
    New-ItemProperty -Path $RegPath -Name "LaunchTo" -PropertyType DWord;
  }

  Set-ItemProperty -Path $RegPath -Name "LaunchTo" -Value 1; # [This PC: 1], [Quick access: 2], [Downloads: 3]
}

function Set-Multitasking-Configuration {
  Write-Host "Configuring Multitasking settings (Snap layouts):" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";

  # When I snap a window, show what I can snap next to it.
  Set-ItemProperty -Path $RegPath -Name "SnapAssist" -Value 0;
  # Show snap layouts that the app is part of when I hover over the taskbar buttons.
  Set-ItemProperty -Path $RegPath -Name "EnableTaskGroups" -Value 0;
  # When I resize a snapped window, simultaneously resize any adjacent snapped window.
  Set-ItemProperty -Path $RegPath -Name "JointResize" -Value 0;

  # Show snap layout when I hover over a window's maximize button.
  Set-ItemProperty -Path $RegPath -Name "EnableSnapAssistFlyout" -Value 0;
  # When I drag a window, let me snap it without dragging all the way to the screen edge.
  Set-ItemProperty -Path $RegPath -Name "DITest" -Value 1;
  # When I snap a window, automatically size it to fill available space.
  Set-ItemProperty -Path $RegPath -Name "SnapFill" -Value 0;

  Write-Host "Multitasking successfully updated." -ForegroundColor "Green";
}

function Set-Classic-ContextMenu-Configuration {
  Write-Host "Activating classic Context Menu:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}";
  $RegKey = "(Default)";

  if (-not (Test-Path -Path $RegPath)) {
    New-Item -Path $RegPath;
  }

  $RegPath = $RegPath | Join-Path -ChildPath "InprocServer32";

  if (-not (Test-Path -Path $RegPath)) {
    New-Item -Path $RegPath;
  }

  if (-not (Test-Path -Path $RegPath -Name $RegKey)) {
    New-ItemProperty -Path $RegPath -Name $RegKey -PropertyType String;
  }
  Set-ItemProperty -Path $RegPath -Name $RegKey -Value "";

  Write-Host "Classic Context Menu successfully activated." -ForegroundColor "Green";
}

function Set-SetAsBackground-To-Extended-ContextMenu {
  Write-Host "Configuring Context Menu to show the option 'Set as Background' just in Extended Context Menu:" -ForegroundColor "Green";

  $Extensions = ".bmp", ".dib", ".gif", ".jfif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff", ".wdp";

  foreach ($Extension in $Extensions) {
    $RegPath = "HKCR:\SystemFileAssociations\${Extension}\Shell\setdesktopwallpaper";

    if (Test-Path $RegPath) {
      if (-not (Test-Path -Path $RegPath -Name "Extended")) {
        New-ItemProperty -Path $RegPath -Name "Extended" -PropertyType String;
      }
    }
  }
}

function Disable-RecentlyOpenedItems-From-JumpList {
  Write-Host "Configuring Jump List to do not show the list of recently opened items:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
  if (-not (Test-Path -Path $RegPath -Name "Start_TrackDocs")) {
    New-ItemProperty -Path $RegPath -Name "Start_TrackDocs" -PropertyType DWord;
  }
  Set-ItemProperty -Path $RegPath -Name "Start_TrackDocs" -Value 0;
}

function Set-Power-Configuration {
  Write-Host "Configuring power plan:" -ForegroundColor "Green";
  # AC: Alternating Current (Wall socket).
  # DC: Direct Current (Battery).

  # Set turn off disk timeout (in minutes / 0: never)
  powercfg -change "disk-timeout-ac" 0;
  powercfg -change "disk-timeout-dc" 0;

  # Set hibernate timeout (in minutes / 0: never)
  powercfg -change "hibernate-timeout-ac" 0;
  powercfg -change "hibernate-timeout-dc" 0;

  # Set sleep timeout (in minutes / 0: never)
  powercfg -change "standby-timeout-ac" 0;
  powercfg -change "standby-timeout-dc" 0;

  # Set turn off screen timeout (in minutes / 0: never)
  powercfg -change "monitor-timeout-ac" 10;
  powercfg -change "monitor-timeout-dc" 10;

  # Set turn off screen timeout on lock screen (in seconds / 0: never)
  powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOCONLOCK 30;
  powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOCONLOCK 30;
  powercfg /SETACTIVE SCHEME_CURRENT;

  Write-Host "Power plan successfully updated." -ForegroundColor "Green";
}

function Set-Custom-Regional-Format {
  Write-Host "Configuring Regional format:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Control Panel\International";

  Set-ItemProperty -Path $RegPath -Name "iFirstDayOfWeek" -Value "0";
  Set-ItemProperty -Path $RegPath -Name "sShortDate" -Value "MM/dd/yyyy";
  Set-ItemProperty -Path $RegPath -Name "sLongDate" -Value "dddd, d MMMM, yyyy";
  Set-ItemProperty -Path $RegPath -Name "sShortTime" -Value "HH:mm";
  Set-ItemProperty -Path $RegPath -Name "sTimeFormat" -Value "HH:mm:ss";

  Write-Host "Regional format successfully updated." -ForegroundColor "Green";
}

function Rename-PC {
  if ($env:COMPUTERNAME -ne $Config.ComputerName) {
    Write-Host "Renaming PC:" -ForegroundColor "Green";

    Rename-Computer -NewName $Config.ComputerName -Force;

    Write-Host "PC renamed, restart it to see the changes." -ForegroundColor "Green";
  } else {
    Write-Host "The PC name is" $Config.ComputerName "so it is not necessary to rename it." -ForegroundColor "Green";
  }
}

Disable-WindowsFeature "WindowsMediaPlayer" "Windows Media Player";
Disable-WindowsFeature "Internet-Explorer-Optional-amd64" "Internet Explorer";
Disable-WindowsFeature "Printing-XPSServices-Features" "Microsoft XPS Document Writer";
Disable-WindowsFeature "WorkFolders-Client" "WorkFolders-Client";
Enable-WindowsFeature "Containers-DisposableClientVM" "Windows Sandbox";

Uninstall-AppPackage "Microsoft.Getstarted";
Uninstall-AppPackage "Microsoft.GetHelp";
Uninstall-AppPackage "Microsoft.WindowsFeedbackHub";
Uninstall-AppPackage "Microsoft.MicrosoftSolitaireCollection";

Set-WindowsExplorer-ShowFileExtensions;
Set-WindowsFileExplorer-StartFolder;
Set-Multitasking-Configuration;
Set-Classic-ContextMenu-Configuration;
Set-SetAsBackground-To-Extended-ContextMenu;
Disable-RecentlyOpenedItems-From-JumpList;
Set-Power-Configuration;
Set-Custom-Regional-Format;
# Rename-PC;

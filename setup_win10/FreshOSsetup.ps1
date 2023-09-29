# Get the folder path of the script
$scriptFolderPath = $PSScriptRoot

# Filenames
$allProgramsFilename        = ".allPrograms.txt"
$selectedProgramsFilename   = ".selectedPrograms.txt"

# Primary Save files (Local Folder)
$allProgramsFilePath            = Join-Path -Path $scriptFolderPath -ChildPath $allProgramsFilename
$selectedProgramsFilePath       = Join-Path -Path $scriptFolderPath -ChildPath $selectedProgramsFilename

# APPDATA Backup Save Folder
$userProfileFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
$relativeScriptPath = "AppData\Local\MARCS_FRESH_OS_PS_SCRIPT\"
$backupSaveFolder   = Join-Path -Path $userProfileFolder -ChildPath $relativeScriptPath
$allProgramsFilePathBackup      = Join-Path -Path $backupSaveFolder -ChildPath $AllProgramsFilename
$selectedProgramsFilePathBackup = Join-Path -Path $backupSaveFolder -ChildPath $selectedProgramsFilename

# Create APPDATA Folders 
if (-not (Test-Path -Path $backupSaveFolder -PathType Container)) {
    New-Item -Path $backupSaveFolder -ItemType Directory
}

# Initialize variables for ChocoPrograms and AllChocoPrograms
$global:ChocoPrograms    = @()
$global:AllChocoPrograms = @()


# Check if the ".allPrograms.save" file exists locally and read its contents if it does
if (Test-Path -Path $allProgramsFilePath -PathType Leaf) {
    $global:AllChocoPrograms = Get-Content -Path $allProgramsFilePath

    # Create Backup APPDATA file
    $global:AllChocoPrograms | Out-File -FilePath $allProgramsFilePathBackup -Encoding UTF8 
}
# Check the APPDATA Backup Folder
elseif (Test-Path -Path "$allProgramsFilePathBackup" -PathType Leaf) {
    $global:AllChocoPrograms = Get-Content -Path $allProgramsFilePathBackup
    # Create local save file
    $global:AllChocoPrograms | Out-File -FilePath $allProgramsFilePath -Encoding UTF8 
}
# Create new AllChocoPrograms array and save files
else {
    # Manually create the program list
    $AllChocoPrograms = @(
        "GoogleChrome",
        "firefox",
        "vivaldi",
        "paint.net",
        "vlc",
        "7zip.install",
        "teamviewer",
        "microsoft-windows-terminal",
        "wsl-debiangnulinux",
        "nircmd",
        "python",
        "vscode",
        "qbittorrent",
        "autohotkey.install",
        "notepadplusplus.install",
        "sublimetext4",
        "winscp.install",
        "filezilla",
        "FoxitReader",
        "DotNet4.5.2",
        "dotnet",
        "dropbox",
        "dotnetcore-sdk",
        "audacity",
        "rufus",
        "etcher",
        "steam",
        "epicgameslauncher",
        "discord.install",
        "origin",
        "lghub",
        "vortex",
        "geforce-experience",
        "nvidia-broadcast",
        "geforce-game-ready-driver",
        "speedtest",
        "bitwarden",
        "wiztree",
        "AndroidStudio",
        "wireguard",
        "f.lux.install",
        "powertoys",
        "voicemeeter-banana.install",
        "spotify",
        "plex",
        "plexmediaplayer",
        "jellyfin-media-player",
        "screentogif.install",
        "unifiedremote",
        "speccy",
        "hass-agent",
        "pia",
        "cura-new",
        "blender",
        "autodesk-fusion360",
        "prusaslicer",
        "eartrumpet",
        "rpi-imager",
        "sandboxie-plus.install",
        "shutup10",
        "cpu-z",
        "wireshark",
        "NETworkManager",
        "winget-cli",
        "nvidia-broadcast",
        "gpu-z",
        "nearby-share",
        "hwinfo.install"
    )

    # Write the file locally and in the APPDATA backup folder
    $global:AllChocoPrograms | Out-File -FilePath $allProgramsFilePath -Encoding UTF8
    $global:AllChocoPrograms | Out-File -FilePath $allProgramsFilePathBackup -Encoding UTF8 
}

# Check if the ".selectedPrograms.save" file exists locally and read its contents if it does
if (Test-Path -Path $selectedProgramsFilePath -PathType Leaf) {
    $global:ChocoPrograms = Get-Content -Path $selectedProgramsFilePath
    # Create Backup APPDATA file
    $global:ChocoPrograms | Out-File -FilePath $selectedProgramsFilePathBackup -Encoding UTF8 
}
# Check the APPDATA Backup Folder
elseif (Test-Path -Path $selectedProgramsFilePathBackup -PathType Leaf) {
    $global:ChocoPrograms = Get-Content -Path $selectedProgramsFilePathBackup
    # Write the file locally and in the APPDATA backup folder
    $global:ChocoPrograms | Out-File -FilePath $selectedProgramsFilename -Encoding UTF8 
}
# Create new ChocoPrograms array and save files
else {
    # Set Equal to the ALL Programs list
    $global:ChocoPrograms = $global:AllChocoPrograms 
    # Write the file locally and in the APPDATA backup folder
    $global:ChocoPrograms | Out-File -FilePath $selectedProgramsFilename -Encoding UTF8 
    $global:ChocoPrograms | Out-File -FilePath $selectedProgramsFilePathBackup -Encoding UTF8 
}

$global:ChocoPrograms    = $global:ChocoPrograms    | Sort-Object
$global:AllChocoPrograms = $global:AllChocoPrograms | Sort-Object



# Title Display
function title-clearScreen {
    Clear-Host
    Write-Host "-----------------------------------------------------" -ForegroundColor Magenta
    Write-Host "-------" -ForegroundColor Magenta -NoNewline
    Write-Host "           Marc's Windows 10           " -NoNewline -ForegroundColor Cyan
    Write-Host "-------" -ForegroundColor Magenta -NoNewline
    Write-Host "              "
    Write-Host "-------" -ForegroundColor Magenta -NoNewline
    Write-Host "  PowerShell Setup/Maintanence Script  " -NoNewline -ForegroundColor Cyan
    Write-Host "-------" -ForegroundColor Magenta -NoNewline
    Write-Host "              "
    Write-Host "-----------------------------------------------------" -ForegroundColor Magenta
    Write-Host "              "
}

function EnterToContinue {
    # Pause before exiting
    Write-Host "`nPress any key to continue..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

# Yes/No prompt
function Get-YesNoInput {
    param (
        [string]$promptString = "Continue?"
    )
    $userInput = Read-Host "$promptString [y/N]"
    if ($userInput -eq "y" -or $userInput -eq "Y") {
        return $true
    }
    return $false
}

# Rename the computer
function Rename-ComputerWithPrompt {
    Format-StringInTemplate "Re-Name Computer"

    # Name of the computer BEFORE a reboot
    $currentComputerName = $env:COMPUTERNAME
    # Name of the computer AFTER a reboot (If it's been changed)
    $newComputerName = Get-ItemPropertyValue -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" -Name "ComputerName"

    do {
        if ($currentComputerName -eq $newComputerName) {
            Write-Host "Current Name: " -NoNewline 
            Write-Host "$currentComputerName" -ForegroundColor Green 
        } else {
            Write-Host "Current Name: " -NoNewline 
            Write-Host "$currentComputerName" -ForegroundColor Yellow 
            Write-Host "    New Name: " -NoNewline 
            Write-Host "$newComputerName" -ForegroundColor Green
        }
        
        Write-Host ""
        $renamePrompt = "Rename This PC?"
        if (Get-YesNoInput $renamePrompt) {
            Write-Host ""
            $newComputerName = Read-Host "Enter the new computer name"
            $result = Rename-Computer -NewName $newComputerName -ErrorVariable renameError -WarningVariable renameWarning -ErrorAction SilentlyContinue
            #Write-Host "Rename Error  : $renameError"
            #Write-Host "Rename Warning: $renameWarning"
            if ($result) {
                Write-Host "Computer successfully renamed to: $newComputerName" -ForegroundColor Green
                break
            } elseif ($renameError -match "The changes will take effect after you restart the computer $currentComputerName.") {
                Write-Host "Computer rename is pending a restart. The new name will take effect after the next restart." -ForegroundColor Green
                break
            } elseif ($renameWarning -match "The changes will take effect after you restart the computer $currentComputerName.") {
                Write-Host "Computer rename is pending a restart. The new name will take effect after the next restart." -ForegroundColor Green
                break
            } elseif ($renameError.Exception.Message -match "Access is denied.") {
                Write-Host "Access is denied. Please Relaunch PowerShell in Admin mode (Sometimes it just needs to be restarted)" -ForegroundColor Yellow
                Write-Host " - You might also need to enter this command before launching this script again: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` "
                Write-Host " - And here's the current Directory: "
                Write-Host "   $PWD" -ForegroundColor Cyan
                Write-Host ""
                Write-Host ""
                Write-Host ""
                exit
            } else {
                Write-Host "Failed to rename the computer. See error details below:" -ForegroundColor Red
                $renameError.Exception.Message
                $renameWarning.Exception.Message
            }
        } else {
            Write-Host "Computer rename process canceled by the user." -ForegroundColor Yellow
            break
        }
    } while ($true)

    Write-Host ""
    if ($currentComputerName -ne $newComputerName) {
        Write-Host "Current Name: " -NoNewline 
        Write-Host "$currentComputerName" -ForegroundColor Yellow 
        Write-Host "    New Name: " -NoNewline 
        Write-Host "$newComputerName" -ForegroundColor Green
    }
}

# Change UAC level
function Set-UACLevel {
    Format-StringInTemplate "Set Users UAC Level"
    $uacInfo = @"
User Account Control (UAC). That annoying 'doodulu' popup that 
dims the background and interputs what you're doing.
Believe me, you're gonna want to choose '0'. 

Please choose the UAC Level:
    0 - Never notify (Not recommended, but you know you want to.. Just do it...)
    1 - Notify me only when apps try to make changes (Dim my desktop)
    2 - Notify me only when apps try to make changes (Do not dim my desktop)
    3 - Always notify (Default. Unless you hate yourself, or this person. No.)
"@
    $uacLevel = Get-ItemPropertyValue -Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin"
    Write-Host $uacInfo -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Current UAC Level: " -NoNewline
    Write-Host $uacLevel -ForegroundColor Green

    if (Get-YesNoInput "Edit UAC?") {
        Write-Host ""
        do {
            $numValue = Read-Host "Enter New UAC Level"
        } while ($numValue -notin '0', '1', '2', '3')

        # Start UAC window to apply changes
        Start-Process -FilePath "C:\Windows\System32\UserAccountControlSettings.exe"

        # Wait for a second
        Start-Sleep -Seconds 1

        $numValue = [int]$numValue
        Set-ItemProperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value $numValue

    } else {
        return
    }

    Write-Host "Once you've submitted the change in the pop-up window, proceed"
    $uacLevel = Get-ItemPropertyValue -Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin"
    Write-Host "New UAC Level: " -NoNewline
    Write-Host $uacLevel -ForegroundColor Green
}

# Install Chocolatey and Chocolatey GUI
Function Install-Chocolatey {
    Format-StringInTemplate "Installing Chocolatey"
    if (-not (Get-Command "choco" -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    choco install chocolateygui -y
}

# Install All programs in the ChocoPrograms array
function Install-Programs {

    Format-StringInTemplate "Installing All Programs using Chocolatey"
    $failedPrograms = ""
    $count=1
    $numOfPrograms=$global:ChocoPrograms.Count

    foreach ($program in $global:ChocoPrograms) {
        Write-Host "--------------------------------" -ForegroundColor Magenta
        Write-Host "-- " -ForegroundColor Magenta -NoNewline
        Write-Host "Installing: $count/$numOfPrograms" -ForegroundColor Cyan
        Write-Host "-- " -ForegroundColor Magenta -NoNewline
        Write-Host "Installing: $($program)" -ForegroundColor Cyan
        Write-Host "--------------------------------" -ForegroundColor Magenta
        choco Install $program -y
        Write-Host "=======================================================================" -ForegroundColor Magenta
        Write-Host "== " -ForegroundColor Magenta -NoNewline
        Write-Host "$($program) INSTALLED SUCCESSFULLY" -ForegroundColor Green
        Write-Host "=======================================================================" -ForegroundColor Magenta
        $count = $count + 1
    }
}

# List all Programs. Toggle which ones will be installed. 
function Print-ChocolateyProgramsList {
    param (
        [string[]]$AllChocoPrograms
    )

    $columnWidth = 36
    $columnNumWidth = (($AllChocoPrograms.Count).ToString().Length) + 2
    $columnCount = 2

    Write-Host "List of Chocolatey Programs to Install:" -ForegroundColor Cyan
    foreach ($i in 0..($AllChocoPrograms.Count - 1)) {
        $number = $i + 1
        $program = $AllChocoPrograms[$i]

        # Convert the numbers to strings
        $totNumString = ($AllChocoPrograms.Count).ToString()
        $numberString = $number.ToString()
        # Determine the desired length based on the length of $number1
        $desiredLength = $totNumString.Length
        # Pad $number2 to match the length of $number1
        $numberPadded = $numberString.PadLeft($desiredLength, '0')

        if ($global:ChocoPrograms -contains $program) {
            $numberColor = "Green"
        } else {
            $numberColor = "Red"
        }

        $formattedText = "{0}. " -f $numberPadded
        Write-Host ("{0,-$columnNumWidth}" -f $formattedText) -ForegroundColor $numberColor -NoNewLine
        Write-Host ("{0,-$columnWidth}" -f $program) -NoNewLine

        # New row, or print on same line
        if ($i % $columnCount -eq 0) {
            Write-Host "" -NoNewLine
        } else {
            Write-Host ""
        }
    }
    Write-Host ""  # Add a new line after printing the list
    Write-Host "X. Exit"  -ForegroundColor Red
    Write-Host ""  # Add a new line after printing the list

    # Prompt for user input
    $userInput = Read-Host "Program to Enable/Disable"
    # Exit the loop if the user enters 'x'
    if ($userInput -eq 'x') { 
        # Save the array to a file for future reference 
        $global:ChocoPrograms | Out-File -FilePath $selectedProgramsFilePath -Encoding UTF8 
        $global:ChocoPrograms | Out-File -FilePath $selectedProgramsFilePathBackup -Encoding UTF8 
        break 
    }
    # Parse the user input as an integer
    $selectedOption = [int]$userInput

    Clear-Host
    Toggle-Program -ProgramNumber $selectedOption -ChocoPrograms $global:ChocoPrograms -AllChocoPrograms $AllChocoPrograms
}

# Add or remove a program from the chocoPrograms array (Which programs to install)
function Toggle-Program {
    param (
        [int]$ProgramNumber,
        [string[]]$AllChocoPrograms
    )

    if ($ProgramNumber -ge 1 -and $ProgramNumber -le $AllChocoPrograms.Count) {
        $ProgramName = $AllChocoPrograms[$ProgramNumber - 1]
        if ($global:ChocoPrograms -contains $ProgramName) {
            $global:ChocoPrograms = $global:ChocoPrograms | Where-Object { $_ -ne $ProgramName }
            #Write-Host "Removed $ProgramName from the installation list."
        } else {
            # Convert the existing array to an ArrayList
            $global:ChocoPrograms = [System.Collections.ArrayList]($global:ChocoPrograms)
            # Now you can add elements to it
            $global:ChocoPrograms.Add("$ProgramName")
            #Write-Host "Added $ProgramName to the installation list."
        }
    } else {
        Write-Host "Invalid program number. Please enter a valid number. $ProgramNumber"
        Enter-To-Continue
    }

    # Sorting the array, so it remains sorted after each toggle
    $global:ChocoPrograms = $global:ChocoPrograms | Sort-Object
    # Dive back into Print Loop
    Print-ChocolateyProgramsList -ChocoPrograms $global:ChocoPrograms -AllChocoPrograms $AllChocoPrograms

}

# Display Function
# Example: Format-StringInTemplate "This is an Example"
#   ----------------------------
#   ---  This is an Example  ---
#   ----------------------------
function Format-StringInTemplate {
    param (
        [string]$inputString
    )

    $templateLine = "-" * ($inputString.Length + 10)
    $spaceLength = $templateLine.Length - $inputString.Length - 4
    $spaces = " " * (($spaceLength / 2) - 1)
    $shortLine = "-" * ($spaces.Length + 1)

    Write-Host $templateLine -ForegroundColor Green
    Write-Host "$shortLine" -ForegroundColor Green -NoNewline
    Write-Host "$spaces$inputString$spaces" -ForegroundColor Cyan -NoNewLine
    Write-Host "$shortLine" -ForegroundColor Green 
    Write-Host $templateLine -ForegroundColor Green
    Write-Host ""
}

function signInOptions {
    Format-StringInTemplate "Sign in Options"
    Write-Host "Please use the Pop up window to set Sign in Options"

    Start-Process "ms-settings:signinoptions"
}

function enableWindowsFeatures {
    # Open Windows Features window
    Start-Process "OptionalFeatures.exe"

    $options = @(
        "Microsoft-Windows-Subsystem-Linux",
        "Microsoft-Hyper-V-All"
    )
    while ($true) {
        # Get the list of Windows features
        $windowsFeatures = Get-WindowsOptionalFeature -Online | Select-Object -ExpandProperty FeatureName

        Clear-Host
        Format-StringInTemplate "Enable Windows Features"

        Write-Host "(SPAWNING WINDOWS FEATURES WINDOW AS WELL)"
        Write-Host 

        # Display menu options
        Write-Host "Select an option to " -NoNewline
        Write-Host "enable" -ForegroundColor Green -NoNewline
        Write-Host "/" -NoNewline
        Write-Host "disable" -ForegroundColor Red -NoNewline
        Write-Host ":"

        for ($i = 0; $i -lt $options.Count; $i++) {
            $feature = Get-WindowsOptionalFeature -FeatureName $options[$i] -Online
            if ($feature.State -eq "Enabled") {
                Write-Host "$($i + 1). $($options[$i])" -ForegroundColor Green
            } else {
                Write-Host "$($i + 1). $($options[$i])" -ForegroundColor Red
            }
        }
        Write-Host ""
        Write-Host "X. " -ForegroundColor Red -NoNewLine
        Write-Host "Exit"
        Write-Host ""
        # Prompt for user input
        $userInput = Read-Host "Select"

        # Exit the loop if the user enters 'x'
        if ($userInput -eq "x") { break }

        # Parse the user input as an integer
        $selectedOption = [int]$userInput
        $feature = $options[$selectedOption - 1]
        $feature = Get-WindowsOptionalFeature -FeatureName $options[$selectedOption - 1] -Online

        $wslFeatureName = $($options[$selectedOption - 1])
        Write-Host "$wslFeatureName"
        $wslStatus = Get-WindowsOptionalFeature -FeatureName $wslFeatureName -Online
        if ($feature.State -eq "Enabled") {
            Disable-WindowsOptionalFeature -FeatureName $wslFeatureName -Online
        } else {
            Enable-WindowsOptionalFeature -FeatureName $wslFeatureName -Online 
        }

        EnterToContinue
        Write-Host ""
    }
}

function backupStartMenu {
    Format-StringInTemplate "Back and Import Start Menu Layout"

    if (Get-YesNoInput "Do you want to backup your Start Menu?") {
        $documentsFolder = Join-Path $env:USERPROFILE "Documents"
        export-startlayout -path "$documentsFolder\startMenuBackup.xml"
    } else {
        return
    }
    Write-Host "COMPLETE: You should now have a file named 'StartMenuBackup.xml' in your documents folder"
    $stringText= @"
==============================================
==== RESTORE OLD START MENU CONFIGURATION ====
==============================================
Importing requires the use of the 'Local Group Policy Editor' (Gpedit.msc). 

Step 1: 
Type 'Gpedit.msc' in the RUN window.
Or 'Gpedit' in the Start Menu.

Step 2:
Navigate to: 
User Configuration > Administrative Templates > Start Menu and Taskbar > Start Layout

Step 3: 
Check 'Enabled' 
Plug in File Path to the .xml backup (D:\Configuration stuff\Win10StartMenu\startMenuBackup.xml)

Step 4:
Apply changes, and reboot PC. 

Step 5: 
Make sure all looks good. 
The Start Menu should now be locked due to the changes we made. To unlock the Start Menu...
"@

    Write-Host $stringText -ForegroundColor Yellow
}

function snapWindows {
    Write-Host "Disable 'When I snap a window, show what I can snap next to it'"
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V "SnapAssist" /T REG_DWORD /D "0" /F
    #Write-Host "Disable 'When I snap a window, automatically size it to fit available space'"
    #reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V "SnapFill" /T REG_DWORD /D "0" /F
    #Write-Host "Disable 'Snap windows' toggle button:"
    #reg add "HKCU\Control Panel\Desktop" /V "WindowArrangementActive" /D "0" /F
    #Write-Host "Disable 'When I resize a snapped window, simultaneously resize any adjacent snapped window'"
    #reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V "JointResize" /T REG_DWORD /D "0" /F

    Write-Host ""
    Write-Host "PLEASE REBOOT FOR CHANGES TO TAKE EFFECT" -ForegroundColor Yellow
}

function toggleLightDarkTheme {
    Format-StringInTemplate "Toggle Light/Dark Theme"
    $themeRegistryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $themeRegistryValueName = "AppsUseLightTheme"

    $currentTheme = Get-ItemPropertyValue -Path $themeRegistryPath -Name $themeRegistryValueName

    # Check the value to determine the current theme
    if ($currentTheme -eq 0) {
        Write-Host "Current theme: Dark"
        $themeRegistryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        $themeRegistryValueName = "AppsUseLightTheme"
        # Set the theme to "Dark" (0 means dark theme, 1 means light theme)
        Set-ItemProperty -Path $themeRegistryPath -Name $themeRegistryValueName -Value 1
        Write-Host "New theme: Light"
    } elseif ($currentTheme -eq 1) {
        Write-Host "Current theme: Light"
        $themeRegistryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        $themeRegistryValueName = "AppsUseLightTheme"
        # Set the theme to "Dark" (0 means dark theme, 1 means light theme)
        Set-ItemProperty -Path $themeRegistryPath -Name $themeRegistryValueName -Value 0
        Write-Host "New theme: Dark"
    } else {
        Write-Host "Unknown theme"
    }
}

function setWorkgroup {
    # Define the new workgroup name
    $newWorkgroupName = "NewWorkgroupName"

    # Set the new workgroup name
    Set-WmiInstance -Class Win32_ComputerSystem -Property @{Workgroup = $newWorkgroupName}

    # Restart the computer to apply the changes
    Restart-Computer
}

function joinDomain {

}

function setDatetimeFormat {

}

function powerSettings {
    # add ultimate power setting. 
}

function backupRegistryKeys {
    
}

function enableRDP {
    Format-StringInTemplate "Enable Remote RDP Connections"

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

    Write-Host "RDP Connection from Remote Computers should now be " -NoNewline
    Write-Host "enabled." -ForegroundColor Green
    Start-Process "ms-settings:remotedesktop"
    Write-Host "But just in case... here's the RDP window"
}

function setWallpaper {
    Format-StringInTemplate "Set New Desktop Wallpaper"
    if (Get-YesNoInput("Would you like to change your current wallpaper?")) {
        return
    }

    $driveLetter = (Split-Path -Path $PSScriptRoot -Qualifier).TrimEnd(":")
    Write
    $directoryPath = Join-Path $driveLetter ":wallpapers"

    # Get all files in the specified directory
    $files = Get-ChildItem -Path $directoryPath -File

    # Display a numbered list of files to the user
    for ($i = 0; $i -lt $files.Count; $i++) {
        Write-Host ("{0}. {1}" -f ($i + 1), $files[$i].Name)
    }

    # Prompt the user to select a file
    $selectedFileIndex = Read-Host "Select a file (1 to $($files.Count))"

    # Validate user input
    if ($selectedFileIndex -match '^\d+$' -and $selectedFileIndex -ge 1 -and $selectedFileIndex -le $files.Count) {
        $selectedFile = $files[$selectedFileIndex - 1]
        return $selectedFile.FullName
    } else {
        Write-Host "Invalid selection. Please enter a valid number."
        return $null
    }

}

function dialogSystem {
    $exitKey = 'x'
    $options = @(
        "Rename Computer",
        "Set UAC Level (0 or 3)",
        "Enable Windows Features",
        "Snap Windows: Disable showing available windows",
        "Sign in Options",
        "Enable RDP",
        "Toggle Light/Dark Theme",
        "Set Desktop Wallpaper"
    )
    while ($true) {
        # Clear the screen
        #title-clearScreen
        Clear-Host
        Format-StringInTemplate "System Settings"

        # Display menu options
        Write-Host "Select an option:"
        for ($i = 0; $i -lt $options.Count; $i++) {
            Write-Host "$($i + 1). " -ForegroundColor Green -NoNewLine
            Write-Host "$($options[$i])"
        }
        Write-Host ""
        Write-Host "X. " -ForegroundColor Green -NoNewLine
        Write-Host "Back to Main Menu"
        Write-Host ""
        $userInput = Read-Host "Select"
        # Exit the loop if the user enters 'x'
        if ($userInput -eq $exitKey) { break }
        # Parse the user input as an integer
        $selectedOption = [int]$userInput
        title-clearScreen
        Clear-Host
        # Execute the selected function based on the user input
        switch ($selectedOption) {
            1 { Rename-ComputerWithPrompt }
            2 { Set-UACLevel }
            3 { enableWindowsFeatures }
            4 { snapWindows }
            5 { signInOptions }
            6 { enableRDP }
            7 { toggleLightDarkTheme }
            8 { setWallpaper }
            default { Write-Host "Invalid option. Please select a valid option." -ForegroundColor Red }
        }

        EnterToContinue
        Write-Host ""
    }

}

function dialogPrograms {
    $exitKey = 'x'
    $options = @(
        "Install Chocolatey",
        "Chocolatey: Install Programs",
        "Chocolatey: List --- Toggle Programs to Install"
        #"Chocolatey: Add/Remove Programs from ALL list"
    )
    while ($true) {
        # Clear the screen
        #title-clearScreen
        Clear-Host
        Format-StringInTemplate "System Settings"

        # Display menu options
        Write-Host "Select an option:"
        for ($i = 0; $i -lt $options.Count; $i++) {
            Write-Host "$($i + 1). " -ForegroundColor Green -NoNewLine
            Write-Host "$($options[$i])"
        }
        Write-Host ""
        Write-Host "X. " -ForegroundColor Green -NoNewLine
        Write-Host "Back to Main Menu"
        Write-Host ""
        # Prompt for user input
        $userInput = Read-Host "Select"
        # Exit the loop if the user enters 'x'
        if ($userInput -eq $exitKey) { break }
        # Parse the user input as an integer
        $selectedOption = [int]$userInput
        Clear-Host
        # Execute the selected function based on the user input
        switch ($selectedOption) {
            1 { Install-Chocolatey }
            2 { Install-Programs -chocoPrograms $global:ChocoPrograms }
            3 { Print-ChocolateyProgramsList -ChocoPrograms $global:ChocoPrograms -AllChocoPrograms $AllChocoPrograms }
            default { Write-Host "Invalid option. Please select a valid option." -ForegroundColor Red }
        }
        EnterToContinue
        Write-Host ""
    }
}

function Remove-FolderAndContents {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$backupSaveFolder,
        [string]$allProgramsFilename,
        [string]$selectedProgramsFilename
    )

    Format-StringInTemplate "Delete Script Generated Files/Folders"

    # Check if the folder exists
    if (Test-Path -Path $backupSaveFolder -PathType Container) {
        # Remove the folder and all its contents recursively
        Remove-Item -Path $backupSaveFolder -Recurse -Force
        Write-Host "DELETED: Folder '$backupSaveFolder'" -ForegroundColor green
    } else {
        Write-Host "DOES NOT EXIST: Folder '$backupSaveFolder'" -ForegroundColor green
    }

    Write-Host ""

    # Check if the file exists
    if (Test-Path -Path $allProgramsFilePath -PathType Leaf) {
        # Remove the folder and all its contents recursively
        Remove-Item -Path $allProgramsFilePath -Recurse -Force
        Write-Host "DELETED:   File '$allProgramsFilePath'" -ForegroundColor green
    } else {
        Write-Host "DOES NOT EXIST:   File '$allProgramsFilePath'" -ForegroundColor green
    }

    # Check if the file exists
    if (Test-Path -Path $selectedProgramsFilePath -PathType Leaf) {
        # Remove the folder and all its contents recursively
        Remove-Item -Path $selectedProgramsFilePath -Recurse -Force
        Write-Host "DELETED:   File '$selectedProgramsFilePath'" -ForegroundColor green
    } else {
        Write-Host "DOES NOT EXIST:   File  $selectedProgramsFilePath'" -ForegroundColor green
    }
}

# Example usage:
# Remove-FolderAndContents -FolderPath "C:\Users\Marc\AppData\Local\MARCS_FRESH_OS_PS_SCRIPT"


function test {
    # Function to colorize output
    function Colorize-Text {
        param (
            [string]$text,
            [string]$foregroundColor
        )
        $coloredText = $text | ForEach-Object { Write-Host $_ -ForegroundColor $foregroundColor -NoNewline }
        Write-Host $coloredText
    }

    # Get all connected monitors
    $monitors = Get-WmiObject -Namespace "root\cimv2" -Class Win32_DesktopMonitor

    foreach ($monitor in $monitors) {
        $monitorName = $monitor.Caption
        $currentWidth = $monitor.ScreenWidth
        $currentHeight = $monitor.ScreenHeight
        $currentRefreshRate = $monitor.RefreshRate

        # Get the monitor orientation from the screen orientation if available
        $orientationValues = @{
            1 = "Portrait"
            2 = "Landscape"
            3 = "Portrait (Flipped)"
            4 = "Landscape (Flipped)"
        }
        if ($monitor.ScreenOrientation -in $orientationValues.Keys) {
            $currentOrientation = $orientationValues[$monitor.ScreenOrientation]
        } else {
            $currentOrientation = "Unknown"
        }

        # Display current monitor information
        Write-Host "Monitor Name: " -NoNewline
        Colorize-Text $monitorName "Yellow"
        Write-Host " | Resolution: " -NoNewline
        Colorize-Text "$currentWidth x $currentHeight" "Cyan"
        Write-Host " | Orientation: " -NoNewline
        Colorize-Text $currentOrientation "Green"
        Write-Host " | Refresh Rate: " -NoNewline
        Colorize-Text "${currentRefreshRate}Hz" "Magenta"

        # Check if refresh rate is set lower than detectable maximum
        $maxRefreshRate = 144  # Replace with the maximum detectable refresh rate for your monitor
        if ($currentRefreshRate -lt $maxRefreshRate) {
            $increaseRefreshRate = Get-YesNoInput "Do you want to increase the refresh rate to its maximum of $maxRefreshRate Hz?"
            if ($increaseRefreshRate) {
                # Implement the refresh rate change logic here (requires low-level API calls)
                # You can use the ChangeDisplaySettingsEx function from user32.dll
                # Note: Changing refresh rate programmatically can be complex and risky. Use caution.
            }
        }

        Write-Host ""
    }
}

$exitKey = 'x'
$options = @(
    "System Settings"
    "Programs"
    "Backup: Start Menu Layout"
    "Script Cleanup (Delete All files/folders produced by this script)"
)

while ($true) {
    # Clear the screen
    title-clearScreen

    # Display menu options
    Write-Host "Select an option:"
    for ($i = 0; $i -lt $options.Count; $i++) {
        Write-Host "$($i + 1). " -ForegroundColor Green -NoNewLine
        Write-Host "$($options[$i])"
    }
    Write-Host ""
    Write-Host "0. " -ForegroundColor Green -NoNewLine
    Write-Host "Test"
    Write-Host "X. " -ForegroundColor Green -NoNewLine
    Write-Host "Exit"
    Write-Host ""
    # Prompt for user input
    $userInput = Read-Host "Select"
    # Exit the loop if the user enters 'x'
    if ($userInput -eq $exitKey) { exit }
    # Parse the user input as an integer
    $selectedOption = [int]$userInput
    Clear-Host
    # Execute the selected function based on the user input
    switch ($selectedOption) {
        1 { dialogSystem }
        2 { dialogPrograms }
        3 { enableWindowsFeatures }
        4 { Remove-FolderAndContents -backupSaveFolder $backupSaveFolder -allProgramsFilename $allProgramsFilename -selectedProgramsFilename selectedProgramsFilename}
        0 { test }
        default { Write-Host "Invalid option. Please select a valid option." -ForegroundColor Red }
    }
    EnterToContinue
    Write-Host ""
}




# Example usage
if (Get-YesNoInput "Do you want to rename the PC?") {
    Rename-ComputerWithPrompt
}
title-clearScreen
if (Get-YesNoInput "Do you want to change the UAC level?") {
    Set-UACLevel
}
title-clearScreen
if (Get-YesNoInput "Do you want to Install Chocolately?") {
    Install-Chocolatey
}
title-clearScreen
if (Get-YesNoInput "Do you want to Install All Programs using Chocolately?") {
    Install-Programs
}

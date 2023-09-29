Set objShell = CreateObject("WScript.Shell")

' Get the path to the folder where the VBA script is located
scriptFolder = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))

' Define the PowerShell script path dynamically
psScriptPath = scriptFolder & "FreshOSsetup.ps1"

' Create a command to run PowerShell as administrator with the specified script
psCommand = "powershell.exe -ExecutionPolicy Bypass -NoProfile -File """ & psScriptPath & """"

' Create a constant for the normal window style
Const NormalWindow = 1

' Run the PowerShell script with administrative privileges in a visible window
objShell.Run psCommand, NormalWindow, True

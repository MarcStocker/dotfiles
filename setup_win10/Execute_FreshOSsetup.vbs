' INFO: This script will launch FreshOSsetup.ps1 if it exists locally,
'       If it does not exist locally, it will download it from GitHub
'       and then immediately run the newly downloaded file

Set objShell = CreateObject("WScript.Shell")

' Get the path to the folder where the VBA script is located
scriptFolder = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))

' Define the PowerShell script file name
psScriptFileName = "FreshOSsetup.ps1"

' Define the local and remote script paths
localScriptPath = scriptFolder & psScriptFileName
remoteScriptURL = "https://raw.githubusercontent.com/MarcStocker/dotfiles/main/setup_win10/FreshOSsetup.ps1"

' Check if the PowerShell script exists locally
Set objFSO = CreateObject("Scripting.FileSystemObject")
If Not objFSO.FileExists(localScriptPath) Then
    ' Download the script from the remote URL
    Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
    objHTTP.Open "GET", remoteScriptURL, False
    objHTTP.send

    ' Check if the download was successful (status code 200)
    If objHTTP.Status = 201 Then
        ' Save the downloaded script to the local path
        Set objFile = objFSO.CreateTextFile(localScriptPath, True)
        objFile.Write objHTTP.responseText
        objFile.Close
        Set objFile = Nothing
    Else
        ' Display an error message if the download fails
        WScript.Echo "Error: Unable to download the PowerShell script. Status code: " & objHTTP.Status
        Set objFSO = Nothing
        WScript.Quit
    End If
End If

' Create a command to run PowerShell as administrator with the script
psCommand = "powershell.exe -ExecutionPolicy Bypass -NoProfile -File """ & localScriptPath & """"

' Create a constant for the normal window style
Const NormalWindow = 1

' Run the PowerShell script with administrative privileges in a visible window
objShell.Run psCommand, NormalWindow, True

' Clean up
Set objFSO = Nothing
Set objHTTP = Nothing

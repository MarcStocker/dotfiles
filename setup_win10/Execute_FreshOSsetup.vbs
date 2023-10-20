' INFO: This script will launch FreshOSsetup.ps1 if it exists locally,
'       If it does not exist locally, it will download it from GitHub
'       and then immediately run the newly downloaded file

' Create a Shell object to execute commands
Set objShell = CreateObject("Shell.Application")

' Get the path to the folder where the VBS script is located
scriptFolder = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))

' Define the PowerShell script file name and the original VBS script name
psScriptFileName = "FreshOSsetup.ps1"
vbScriptFileName = "Execute_FreshOSsetup.vbs"

' Define the local and remote script paths
localScriptPath = scriptFolder & psScriptFileName
remoteScriptURL = "https://raw.githubusercontent.com/MarcStocker/dotfiles/main/setup_win10/FreshOSsetup.ps1"
vbsScriptURL = "https://raw.githubusercontent.com/MarcStocker/dotfiles/main/setup_win10/Execute_FreshOSsetup.vbs"

' Function to download a file from a URL
Function DownloadFile(url, localPath)
    Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
    objHTTP.Open "GET", url, False
    objHTTP.send

    If objHTTP.Status = 200 Or objHTTP.Status = 201 Then
        Set objStream = CreateObject("ADODB.Stream")
        objStream.Open
        objStream.Type = 1 ' Binary
        objStream.Write objHTTP.responseBody
        objStream.SaveToFile localPath, 2 ' Overwrite
        objStream.Close
        Set objStream = Nothing
    Else
        WScript.Echo "Error: Unable to download the file. Status code: " & objHTTP.Status
        WScript.Quit
    End If
End Function

' Function to compare two files
Function FilesAreDifferent(localFilePath, remoteURL)
    Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
    objHTTP.Open "GET", remoteURL, False
    objHTTP.send

    If objHTTP.Status = 200 Or objHTTP.Status = 201 Then
        ' Fetch the content of the remote file
        remoteContents = objHTTP.responseText

        ' Read the content of the local file
        localContents = ReadFile(localFilePath)

        ' Compare the contents of the local and remote files
        FilesAreDifferent = (localContents <> remoteContents)
    Else
        ' If unable to download the remote file, return true
        FilesAreDifferent = True
    End If
End Function

' Function to read a file's contents
Function ReadFile(filePath)
    Dim objFSO, objFile, fileContents
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFile = objFSO.OpenTextFile(filePath, 1)
    fileContents = objFile.ReadAll
    objFile.Close
    Set objFile = Nothing
    Set objFSO = Nothing
    ReadFile = fileContents
End Function

' Function to prompt the user
Function PromptForUpdate(scriptName)
    Dim response
    response = MsgBox("A newer version of the " & scriptName & " is available. Do you want to update it?", vbYesNoCancel + vbQuestion, "Update Script")
    
    Select Case response
        Case vbYes
            PromptForUpdate = "Yes"
        Case vbNo
            PromptForUpdate = "No"
        Case vbCancel
            PromptForUpdate = "Cancel"
    End Select
End Function

' Check if the VBS script is different on GitHub
If FilesAreDifferent(WScript.ScriptFullName, vbsScriptURL) Then
    ' Prompt the user to update the VBS script
    Dim vbsPrompt
    vbsPrompt = PromptForUpdate("VBS script")
    
    If vbsPrompt = "Yes" Then
        ' Download the updated VBS script as a temporary file
        ' tempScriptPath = scriptFolder & "temp_" & vbScriptFileName
        tempScriptPath = scriptFolder & vbScriptFileName
        DownloadFile vbsScriptURL, tempScriptPath

        ' Run the updated VBS script
        Set objShell = CreateObject("WScript.Shell")
        objShell.Run "wscript """ & tempScriptPath & """", 1, True

        ' Replace the original VBS script with the updated one
        Set objFSO = CreateObject("Scripting.FileSystemObject")
        objFSO.DeleteFile WScript.ScriptFullName ' Delete the original script
        objFSO.MoveFile tempScriptPath, WScript.ScriptFullName ' Rename the temp script to the original name
        Set objFSO = Nothing

        Dim response
        response = MsgBox(vbScriptFileName & " script has been updated. Please relaunch the script.", vbInformation, "UPDATED - Relaunch Script")
        ' Exit the current script
        WScript.Quit
    ElseIf vbsPrompt = "Cancel" Then
        ' User canceled, exit the script
        WScript.Quit
    End If
End If

' Check if the PowerShell script exists locally
Set objFSO = CreateObject("Scripting.FileSystemObject")
If Not objFSO.FileExists(localScriptPath) Then
    ' Download the PowerShell script from the remote URL
    Set objShell = CreateObject("WScript.Shell")
    objShell.Run "wscript """ & WScript.ScriptFullName & """", 1, True
ElseIf FilesAreDifferent(localScriptPath, remoteScriptURL) Then
    ' Prompt the user to update the local .ps1 script
    Dim psPrompt
    psPrompt = PromptForUpdate("PowerShell script")
    
    If psPrompt = "Yes" Then
        ' Download the updated .ps1 script
        DownloadFile remoteScriptURL, localScriptPath
    ElseIf psPrompt = "Cancel" Then
        ' User canceled, exit the script
        WScript.Quit
    End If
End If

' Run the PowerShell script with elevated privileges
objShell.ShellExecute "powershell.exe", "-ExecutionPolicy Bypass -NoProfile -File """ & localScriptPath & """", "", "runas", 1

' Clean up
Set objFSO = Nothing

' Exit the current script
WScript.Quit

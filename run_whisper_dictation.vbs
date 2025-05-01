Set WShell = CreateObject("WScript.Shell")
strPath = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
WShell.CurrentDirectory = strPath
WShell.Run Chr(34) & strPath & "\run_whisper_dictation.bat" & Chr(34), 0, False 
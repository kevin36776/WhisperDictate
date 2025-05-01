Set WShell = CreateObject("WScript.Shell")
WShell.CurrentDirectory = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
WShell.Run """" & WShell.CurrentDirectory & "\run_whisper_dictation.bat""", 0, False 
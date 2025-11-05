Set WShell = CreateObject("WScript.Shell")
strPath = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
WShell.CurrentDirectory = strPath

' Run Python directly without showing a terminal window
pythonPath = "C:\venvs\whispervenv\Scripts\python.exe"
scriptPath = strPath & "\dictation_app.py"
WShell.Run Chr(34) & pythonPath & Chr(34) & " " & Chr(34) & scriptPath & Chr(34), 0, False 
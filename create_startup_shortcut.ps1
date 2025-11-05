$WshShell = New-Object -ComObject WScript.Shell
$StartupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$ShortcutPath = Join-Path $StartupFolder "WhisperDictation.lnk"
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "C:\Users\Kevin\OneDrive\WhisperDictation\WhisperDictate\run_whisper_dictation.vbs"
$Shortcut.WorkingDirectory = "C:\Users\Kevin\OneDrive\WhisperDictation\WhisperDictate"
$Shortcut.Description = "Whisper Dictation - Voice to Text"
$Shortcut.Save()

Write-Host "Shortcut created successfully at: $ShortcutPath"
Write-Host "Whisper Dictation will now start automatically when you log in to Windows!"

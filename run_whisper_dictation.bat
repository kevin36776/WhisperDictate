@echo off
cd /d "%~dp0"
call dictate-env\Scripts\activate.bat
python dictation_app.py
if errorlevel 1 pause 

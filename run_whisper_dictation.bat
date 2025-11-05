@echo off
setlocal
cd /d "%~dp0"

set "LOG_DIR=%~dp0logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
set "LOG_FILE=%LOG_DIR%\whisper_dictation.log"

call :log "Launcher started."

set "PYTHON_CMD="

REM Check for venv at C:\venvs\whispervenv first
if exist "C:\venvs\whispervenv\Scripts\activate.bat" (
    call "C:\venvs\whispervenv\Scripts\activate.bat" >> "%LOG_FILE%" 2>&1
    set "PYTHON_CMD=python"
    call :log "Using virtual environment: C:\venvs\whispervenv"
    goto run_app
)

REM Then check for venvs in project directory
for %%d in (dictate-env .venv venv env whisp whisp_backup) do (
    if exist "%~dp0%%d\Scripts\activate.bat" (
        call "%~dp0%%d\Scripts\activate.bat" >> "%LOG_FILE%" 2>&1
        set "PYTHON_CMD=python"
        call :log "Using virtual environment: %%d"
        goto run_app
    )
)

for %%p in (py.exe py) do (
    for /f "delims=" %%I in ('where %%p 2^>nul') do (
        set "PYTHON_CMD=%%I"
        call :log "Using interpreter: %%I"
        goto run_app
    )
)

for %%p in (python3.exe python.exe python3 python) do (
    for /f "delims=" %%I in ('where %%p 2^>nul') do (
        set "PYTHON_CMD=%%I"
        call :log "Using interpreter: %%I"
        goto run_app
    )
)

call :log "ERROR: Python interpreter not found on PATH."
exit /b 1

:run_app
if not defined PYTHON_CMD (
    call :log "ERROR: Python command is not set."
    exit /b 1
)

call :log "Starting dictation_app.py"
if /I "%PYTHON_CMD%"=="python" (
    python "%~dp0dictation_app.py" >> "%LOG_FILE%" 2>&1
) else if /I "%PYTHON_CMD%"=="python.exe" (
    python.exe "%~dp0dictation_app.py" >> "%LOG_FILE%" 2>&1
) else if /I "%PYTHON_CMD%"=="python3" (
    python3 "%~dp0dictation_app.py" >> "%LOG_FILE%" 2>&1
) else if /I "%PYTHON_CMD%"=="python3.exe" (
    python3.exe "%~dp0dictation_app.py" >> "%LOG_FILE%" 2>&1
) else if /I "%PYTHON_CMD%"=="py" (
    py "%~dp0dictation_app.py" >> "%LOG_FILE%" 2>&1
) else if /I "%PYTHON_CMD%"=="py.exe" (
    py.exe "%~dp0dictation_app.py" >> "%LOG_FILE%" 2>&1
) else (
    "%PYTHON_CMD%" "%~dp0dictation_app.py" >> "%LOG_FILE%" 2>&1
)
set "RC=%ERRORLEVEL%"
if "%RC%"=="0" (
    call :log "Whisper Dictation exited normally."
) else (
    call :log "ERROR: Whisper Dictation exited with code %RC%."
)
exit /b %RC%

:log
setlocal enabledelayedexpansion
set "MESSAGE=%~1"
if not defined MESSAGE set "MESSAGE="
echo [%date% %time%] !MESSAGE!>>"%LOG_FILE%"
endlocal
exit /b 0

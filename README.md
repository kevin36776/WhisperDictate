# WhisperDictation

A simple dictation tool that uses OpenAI's Whisper model for real-time speech-to-text transcription. Hold Ctrl+Alt to record your voice, and release to automatically transcribe and paste the text.

## ✨ Features

- Real-time voice recording with Ctrl+Alt hotkey
- Automatic transcription using Whisper AI
- System tray integration
- Automatic clipboard paste of transcribed text
- Support for English language

## 📋 Requirements

- Python 3.7+
- FFmpeg
- Windows OS

## 🚀 Installation Guide

### Step 1: Prerequisites

1. **Open PowerShell as Administrator**
2. **Install Chocolatey** (if not already installed):
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```
3. **Install FFmpeg**:
   ```powershell
   choco install ffmpeg -y
   ```
4. **Verify FFmpeg**:
   ```powershell
   ffmpeg -version
   ```

### Step 2: Project Setup

1. **Clone Repository**:
   ```powershell
   cd C:\
   git clone https://github.com/kevin36776/WhisperDictate.git
   cd WhisperDictate
   ```
2. **Create & Activate Virtual Environment**:
   ```powershell
   python -m venv whisp
   .\whisp\Scripts\activate
   ```

### Step 3: Install Dependencies

```powershell
python -m pip install --upgrade pip
pip install openai-whisper pyaudio keyboard pystray pillow pyperclip
```

### Step 4: Create Models Directory

```powershell
mkdir models
```

### Step 5: Run Application

```powershell
python dictation_app.py
```

## 🎯 How to Use

1. Hold Ctrl+Alt to start recording
2. Release Ctrl+Alt to stop recording and transcribe
3. The transcribed text will be automatically pasted at your cursor position

## 🚀 Setting Up Automatic Startup

### Option 1: Using Task Scheduler

1. **Set Up Task Scheduler**:
   - Open Task Scheduler (press Windows key and type "Task Scheduler")
   - Click "Create Basic Task..." in the right panel
   - Name: "WhisperDictation"
   - Description: "Runs WhisperDictation app at startup"
   - Trigger: Choose "When I log on"
   - Action: "Start a program"
   - Program/script: Browse to and select the `run_whisper_dictation.vbs` file

2. **Configure Advanced Settings**:
   - After creating the task, find it in Task Scheduler Library
   - Right-click and select "Properties"
   - In "General" tab:
     - Check "Run with highest privileges"
     - Change "Configure for" to your Windows version
   - In "Conditions" tab:
     - Uncheck "Start the task only if the computer is on AC power"
     - Uncheck "Stop if the computer switches to battery power"
   - In "Settings" tab:
     - Check "Allow task to be run on demand"
     - Check "Run task as soon as possible after a scheduled start is missed"
   - Click "OK" to save

3. **Testing the Setup**:
   - Right-click the task in Task Scheduler
   - Select "Run"
   - Try the Ctrl+Alt hotkey to verify it's working

Note: The task won't appear in Task Manager's Startup tab as it uses Task Scheduler instead. To disable automatic startup, open Task Scheduler, find the WhisperDictation task, and select "Disable".

This project uses OpenAI's Whisper model for speech recognition. 

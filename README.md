# WhisperDictation

WhisperDictation is a simple dictation tool that uses OpenAI's Whisper model for real-time speech-to-text transcription. Hold Ctrl+Alt to record your voice and release to transcribe and paste the text. I didn't want to pay for whisperflow so I made this.

## Features

- Voice recording with Ctrl+Alt hotkey
- Automatic transcription with Whisper
- System tray integration
- Text pasted automatically at cursor
- Works on Windows with English

## Requirements

- Python 3.7+
- FFmpeg
- Windows

## Installation

### 1. Install FFmpeg

Pick one method:

**Chocolatey (recommended):**

Chocolately Install:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

FFmpeg Install:
```powershell
choco install ffmpeg -y
```

**Scoop install option:**
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex
scoop install ffmpeg
```

**or Manual:**
Download FFmpeg from [ffmpeg.org](https://ffmpeg.org), extract it, and add the bin folder to PATH.

### 2. Clone the Project

```bash
git clone https://github.com/kevin36776/WhisperDictate.git
```

### 3. Create and Activate Virtual Environment

```bash
cd WhisperDictate
python -m venv dictate-env
.\dictate-env\Scripts\activate
```

### 4. Install Dependencies

**Upgrade pip:**
```bash
python -m pip install --upgrade pip
```

**Install Torch:**

With NVIDIA GPU:
```bash
pip install torch --index-url https://download.pytorch.org/whl/cu121
```

CPU only:
```bash
pip install torch
```

**Install remaining requirements:**
```bash
pip install -r requirements.txt
```

If PyAudio fails:
```bash
pip install pipwin
pipwin install pyaudio
```

### 5. Run

```bash
python dictation_app.py
```

## Usage

- Hold **Ctrl+Alt** to start recording
- Release **Ctrl+Alt** to stop and transcribe
- Text is pasted automatically at your cursor

## Startup (optional)

You can use Task Scheduler to run WhisperDictation on startup. Create a basic task, choose "When I log on," and point it to run_whisper_dictation.vbs. Adjust settings so it runs with highest privileges and works on battery power if needed.

To disable, open Task Scheduler and disable the task.

## License

This project is licensed under the MIT License.

---

*This is an independent project and not affiliated with Whisper Flow or OpenAI.*

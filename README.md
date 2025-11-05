# WhisperDictate

A simple voice dictation tool using OpenAI's Whisper model. Hold a hotkey to record, release to transcribe and auto-paste. Free alternative to paid dictation services.

## Features

- Voice recording with Ctrl+Alt hotkey
- Optional right-click + thumb button recording trigger
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

**Chocolatey (recommended):**
```powershell
choco install ffmpeg -y
```

**Or Scoop:**
```powershell
scoop install ffmpeg
```

### 2. Clone & Setup

```bash
git clone https://github.com/kevin36776/WhisperDictate.git
cd WhisperDictate
python -m venv dictate-env
.\dictate-env\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

**If PyAudio fails:**
```bash
pip install pipwin && pipwin install pyaudio
```

**GPU Support (optional):**
```bash
pip install torch --index-url https://download.pytorch.org/whl/cu121
```

### 4. Run

```bash
python dictation_app.py
```

Or double-click `run_whisper_dictation.vbs` for silent background startup.

## Usage

- Hold **Ctrl+Alt** or **right-click + thumb button** to start recording
- Release the keys/buttons to stop and transcribe
- Text is pasted automatically at your cursor

## Auto-Start on Login (Optional)

Run this PowerShell script to add WhisperDictation to your Startup folder:

```powershell
powershell -ExecutionPolicy Bypass -File create_startup_shortcut.ps1
```

This creates a shortcut in your Startup folder so the app launches automatically when you log in.

**To remove auto-start:** Press `Win+R`, type `shell:startup`, and delete the WhisperDictation shortcut.

## License

This project is licensed under the MIT License.

---

*This is an independent project and not affiliated with Whisper Flow or OpenAI.*

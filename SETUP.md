# WhisperDictation Setup Guide

This guide covers automated and manual setup for WhisperDictation on Windows 11.

## Quick Start (Automated)

Run PowerShell as Administrator and execute:

```powershell
cd C:\WhisperDictation
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup.ps1
```

That's it! The script handles everything automatically.

---

## What the Setup Script Does

1. **Installs Python 3.12** (via winget)
2. **Installs FFmpeg** (via winget)
3. **Creates virtual environment** (`dictate-env/`)
4. **Detects your GPU** and installs the optimal PyTorch:
   - RTX 50-series (Blackwell): PyTorch Nightly + CUDA 12.8
   - RTX 40-series (Ada Lovelace): PyTorch Stable + CUDA 12.4
   - RTX 30-series (Ampere): PyTorch Stable + CUDA 12.4
   - RTX 20-series (Turing): PyTorch Stable + CUDA 12.4
   - No GPU: PyTorch CPU
5. **Installs all dependencies**
6. **Adds to Windows Startup** (runs on boot)

---

## Hardware Profiles

### Desktop: RTX 5080 + Ryzen 9 9950X3D + 64GB RAM

| Setting | Value |
|---------|-------|
| PyTorch | Nightly (2.10+) |
| CUDA | 12.8 |
| Model | `turbo` |
| VRAM Usage | ~6GB |
| Device | `cuda` |

**Why Nightly?** RTX 50-series (Blackwell architecture, sm_120) requires PyTorch nightly builds. Stable PyTorch doesn't support sm_120 yet.

```powershell
# PyTorch install command for RTX 50-series:
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128
```

### Laptop: RTX 4060 + Intel i9-13980HX + 32GB RAM

| Setting | Value |
|---------|-------|
| PyTorch | Stable (2.6+) |
| CUDA | 12.4 |
| Model | `turbo` |
| VRAM Usage | ~6GB |
| Device | `cuda` |

**Why Stable?** RTX 40-series (Ada Lovelace architecture, sm_89) is fully supported by stable PyTorch.

```powershell
# PyTorch install command for RTX 40-series:
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
```

---

## Whisper Models

| Model | VRAM | Speed | Accuracy | Best For |
|-------|------|-------|----------|----------|
| `turbo` | ~6GB | 6x faster | 98-99% | **Recommended** - Best balance |
| `large-v3` | ~10GB | Baseline | 100% | Maximum accuracy |
| `medium` | ~5GB | 2x faster | 95% | Lower VRAM GPUs |
| `small` | ~2GB | 4x faster | 90% | Very limited VRAM |
| `base` | ~1GB | 7x faster | 85% | CPU-only systems |

The default is `turbo` - it's only 1-2% less accurate than `large-v3` but 6x faster.

To change the model, edit `dictation_app.py` line 22:
```python
model = whisper.load_model("turbo", device=device)  # Change "turbo" to your choice
```

---

## Manual Setup (Step-by-Step)

If the automated script fails, follow these steps:

### 1. Install Prerequisites

```powershell
# Install Python 3.12
winget install Python.Python.3.12

# Install FFmpeg
winget install Gyan.FFmpeg

# Refresh PATH (or restart terminal)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

### 2. Create Virtual Environment

```powershell
cd C:\WhisperDictation
python -m venv dictate-env
.\dictate-env\Scripts\Activate.ps1
pip install --upgrade pip
```

### 3. Install PyTorch (choose one)

```powershell
# For RTX 50-series (Blackwell):
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128

# For RTX 40/30/20-series:
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# For CPU only:
pip install torch torchvision torchaudio
```

### 4. Install Dependencies

```powershell
pip install -r requirements.txt
```

### 5. Add to Windows Startup

```powershell
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WhisperDictation.lnk")
$Shortcut.TargetPath = "C:\WhisperDictation\run_whisper_dictation.vbs"
$Shortcut.WorkingDirectory = "C:\WhisperDictation"
$Shortcut.Save()
```

### 6. Test

```powershell
.\dictate-env\Scripts\python.exe dictation_app.py
```

---

## Usage

### Hotkeys

| Hotkey | Action |
|--------|--------|
| **Hold Ctrl+Alt** | Start recording |
| **Release Ctrl+Alt** | Stop recording, transcribe, paste |
| **Right-click + Thumb button** | Alternative trigger |

### Starting WhisperDictation

- **Auto**: Starts automatically on Windows login
- **Manual**: Double-click `run_whisper_dictation.bat`

### System Tray

WhisperDictation runs in the system tray. Right-click the icon to exit.

---

## Troubleshooting

### "CUDA not available"

1. Check NVIDIA drivers are installed
2. Verify GPU is detected: `nvidia-smi`
3. Reinstall PyTorch with correct CUDA version

### "Model not found"

Upgrade openai-whisper:
```powershell
pip install --upgrade openai-whisper
```

### "PyTorch not compatible with GPU"

For RTX 50-series, you MUST use nightly:
```powershell
pip uninstall torch torchvision torchaudio -y
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128
```

### Slow transcription

1. Verify GPU is being used (check console output for "Using device: cuda")
2. Ensure you're using `turbo` model, not `large-v3`
3. Check VRAM isn't maxed out by other apps

---

## For AI Coding Agents

When setting up WhisperDictation on a new system:

1. **Clone the repo** to `C:\WhisperDictation`
2. **Run `setup.ps1`** as Administrator - it handles everything automatically
3. **Verify** by checking the console output shows CUDA is available

The setup script auto-detects GPU generation and installs the correct PyTorch version:
- `RTX 50xx` pattern → nightly + cu128
- `RTX 40xx` pattern → stable + cu124
- `RTX 30xx` pattern → stable + cu124
- `RTX 20xx` or `GTX 16xx` pattern → stable + cu124
- No NVIDIA GPU → CPU version

Key files:
- `setup.ps1` - Automated setup script
- `dictation_app.py` - Main application (line 22 sets the model)
- `requirements.txt` - Python dependencies
- `run_whisper_dictation.vbs` - Silent launcher for Windows Startup

---

## File Structure

```
C:\WhisperDictation\
├── dictate-env/           # Python virtual environment
├── logs/                  # Application logs
├── dictation_app.py       # Main application
├── requirements.txt       # Python dependencies
├── setup.ps1              # Automated setup script
├── run_whisper_dictation.bat   # Console launcher
├── run_whisper_dictation.vbs   # Silent launcher
├── SETUP.md               # This file
└── README.md              # Project overview
```

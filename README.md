# README.md — WhisperDictation
# Everything in one PowerShell block for easy copy/paste

# ===== About =====
# WhisperDictation is a simple dictation tool that uses OpenAI Whisper for speech-to-text.
# Hotkey: hold Ctrl+Alt to record, release to transcribe and paste.

# ===== Requirements =====
# - Windows
# - Python 3.7+
# - FFmpeg

# ===== 1) Install FFmpeg (pick ONE method) =====

# --- Chocolatey (recommended) ---
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = `
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install ffmpeg -y
ffmpeg -version

# --- Scoop (alternative) ---
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# iwr -useb get.scoop.sh | iex
# scoop install ffmpeg
# ffmpeg -version

# --- Manual (alternative) ---
# Download from https://ffmpeg.org/download.html
# Extract (e.g., C:\ffmpeg) and add C:\ffmpeg\bin to PATH
# Close/reopen terminal, then:
# ffmpeg -version

# ===== 2) Clone Project =====
cd C:\
git clone https://github.com/kevin36776/WhisperDictate.git
cd WhisperDictate

# ===== 3) Create and Activate Virtual Environment =====
python -m venv dictate-env
.\dictate-env\Scripts\activate

# ===== 4) Install Dependencies =====
python -m pip install --upgrade pip

# Install Torch (pick ONE)
# If you have NVIDIA GPU (CUDA 12.1 wheels):
# pip install torch --index-url https://download.pytorch.org/whl/cu121
# CPU only:
pip install torch

# Install remaining requirements
pip install -r requirements.txt

# If PyAudio fails on Windows, use pipwin:
# pip install pipwin
# pipwin install pyaudio

# ===== 5) First Run =====
python dictation_app.py

# ===== Usage =====
# - Hold Ctrl+Alt to start recording
# - Release Ctrl+Alt to transcribe
# - Text pastes at the cursor

# ===== Optional: Run at Startup via Task Scheduler =====
# 1) Open Task Scheduler -> Create Basic Task
# 2) Name: WhisperDictation
# 3) Trigger: When I log on
# 4) Action: Start a program -> select run_whisper_dictation.vbs
# 5) Properties:
#    - General: Run with highest privileges
#    - Conditions: allow on battery
#    - Settings: allow run on demand; run ASAP if missed
# To disable later: open Task Scheduler and Disable the task

# ===== License (MIT) =====
# Copyright (c) 2025 Kevin Dzitkowski
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# ===== Notes =====
# - This is an independent project. Not affiliated with Whisper Flow or OpenAI.
# - Keep "models" and virtual env folders out of git.

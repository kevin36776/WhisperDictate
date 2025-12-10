#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Automated WhisperDictation setup script for Windows 11

.DESCRIPTION
    This script automatically:
    1. Installs Python 3.12 and FFmpeg (via winget)
    2. Creates a Python virtual environment
    3. Detects your GPU and installs the optimal PyTorch version
    4. Installs all dependencies
    5. Adds WhisperDictation to Windows Startup

.PARAMETER SkipStartup
    Skip adding to Windows Startup

.PARAMETER Model
    Whisper model to use: "turbo" (default, fast+accurate) or "large-v3" (max accuracy)

.EXAMPLE
    .\setup.ps1
    .\setup.ps1 -Model "large-v3"
    .\setup.ps1 -SkipStartup
#>

param(
    [switch]$SkipStartup,
    [ValidateSet("turbo", "large-v3")]
    [string]$Model = "turbo"
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  WhisperDictation Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check/Install Python
Write-Host "[1/6] Checking Python..." -ForegroundColor Yellow
$pythonInstalled = $false
try {
    $pythonVersion = python --version 2>&1
    if ($pythonVersion -match "Python 3\.\d+") {
        Write-Host "  Found: $pythonVersion" -ForegroundColor Green
        $pythonInstalled = $true
    }
} catch {}

if (-not $pythonInstalled) {
    Write-Host "  Installing Python 3.12..." -ForegroundColor Yellow
    winget install Python.Python.3.12 --accept-package-agreements --accept-source-agreements
    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "  Python installed!" -ForegroundColor Green
}

# Step 2: Check/Install FFmpeg
Write-Host "[2/6] Checking FFmpeg..." -ForegroundColor Yellow
$ffmpegInstalled = $false
try {
    $ffmpegVersion = ffmpeg -version 2>&1
    if ($ffmpegVersion -match "ffmpeg version") {
        Write-Host "  Found: FFmpeg installed" -ForegroundColor Green
        $ffmpegInstalled = $true
    }
} catch {}

if (-not $ffmpegInstalled) {
    Write-Host "  Installing FFmpeg..." -ForegroundColor Yellow
    winget install Gyan.FFmpeg --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "  FFmpeg installed!" -ForegroundColor Green
}

# Refresh PATH after installations
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Step 3: Create virtual environment
Write-Host "[3/6] Creating virtual environment..." -ForegroundColor Yellow
$venvPath = Join-Path $ScriptDir "dictate-env"
if (Test-Path $venvPath) {
    Write-Host "  Virtual environment already exists" -ForegroundColor Green
} else {
    python -m venv $venvPath
    Write-Host "  Created: dictate-env" -ForegroundColor Green
}

$pipPath = Join-Path $venvPath "Scripts\pip.exe"
$pythonPath = Join-Path $venvPath "Scripts\python.exe"

# Upgrade pip
& $pipPath install --upgrade pip | Out-Null

# Step 4: Detect GPU and install PyTorch
Write-Host "[4/6] Detecting GPU and installing PyTorch..." -ForegroundColor Yellow

# Detect NVIDIA GPU
$gpuInfo = ""
$gpuGeneration = "unknown"
try {
    $gpu = Get-WmiObject Win32_VideoController | Where-Object { $_.Name -match "NVIDIA" } | Select-Object -First 1
    if ($gpu) {
        $gpuInfo = $gpu.Name
        Write-Host "  Detected: $gpuInfo" -ForegroundColor Cyan

        # Determine GPU generation
        if ($gpuInfo -match "RTX\s*50[0-9][0-9]") {
            $gpuGeneration = "blackwell"  # RTX 50-series (Blackwell) - needs nightly
        } elseif ($gpuInfo -match "RTX\s*40[0-9][0-9]") {
            $gpuGeneration = "ada"  # RTX 40-series (Ada Lovelace) - stable works
        } elseif ($gpuInfo -match "RTX\s*30[0-9][0-9]") {
            $gpuGeneration = "ampere"  # RTX 30-series (Ampere) - stable works
        } elseif ($gpuInfo -match "RTX\s*20[0-9][0-9]|GTX\s*16[0-9][0-9]") {
            $gpuGeneration = "turing"  # RTX 20-series/GTX 16-series (Turing) - stable works
        } else {
            $gpuGeneration = "older"
        }
    }
} catch {
    Write-Host "  No NVIDIA GPU detected, will use CPU" -ForegroundColor Yellow
}

# Install appropriate PyTorch version
if ($gpuGeneration -eq "blackwell") {
    Write-Host "  Installing PyTorch Nightly (CUDA 12.8) for RTX 50-series..." -ForegroundColor Yellow
    & $pipPath install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128
} elseif ($gpuGeneration -ne "unknown" -and $gpuGeneration -ne "older") {
    Write-Host "  Installing PyTorch Stable (CUDA 12.4) for RTX 20/30/40-series..." -ForegroundColor Yellow
    & $pipPath install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
} else {
    Write-Host "  Installing PyTorch CPU version..." -ForegroundColor Yellow
    & $pipPath install torch torchvision torchaudio
}
Write-Host "  PyTorch installed!" -ForegroundColor Green

# Step 5: Install requirements
Write-Host "[5/6] Installing dependencies..." -ForegroundColor Yellow
$requirementsPath = Join-Path $ScriptDir "requirements.txt"
& $pipPath install -r $requirementsPath
Write-Host "  Dependencies installed!" -ForegroundColor Green

# Step 6: Add to Windows Startup
if (-not $SkipStartup) {
    Write-Host "[6/6] Adding to Windows Startup..." -ForegroundColor Yellow
    $WshShell = New-Object -ComObject WScript.Shell
    $StartupPath = [Environment]::GetFolderPath('Startup')
    $ShortcutPath = Join-Path $StartupPath "WhisperDictation.lnk"
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = Join-Path $ScriptDir "run_whisper_dictation.vbs"
    $Shortcut.WorkingDirectory = $ScriptDir
    $Shortcut.Description = "Whisper Dictation - Voice to Text"
    $Shortcut.Save()
    Write-Host "  Added to Startup!" -ForegroundColor Green
} else {
    Write-Host "[6/6] Skipping Windows Startup (use -SkipStartup was specified)" -ForegroundColor Yellow
}

# Verify installation
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verifying Installation..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$verifyScript = @"
import torch
import whisper

print(f"PyTorch: {torch.__version__}")
print(f"CUDA Available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"GPU: {torch.cuda.get_device_name(0)}")
    print(f"VRAM: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB")
print(f"Whisper: Ready")
"@

& $pythonPath -c $verifyScript

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "To start WhisperDictation:" -ForegroundColor White
Write-Host "  - Double-click: run_whisper_dictation.bat" -ForegroundColor Gray
Write-Host "  - Or restart your computer (auto-starts)" -ForegroundColor Gray
Write-Host ""
Write-Host "Hotkeys:" -ForegroundColor White
Write-Host "  - Hold Ctrl+Alt to record" -ForegroundColor Gray
Write-Host "  - Release to transcribe and paste" -ForegroundColor Gray
Write-Host "  - Or: Right-click + Thumb button" -ForegroundColor Gray
Write-Host ""

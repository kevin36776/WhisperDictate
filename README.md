# WhisperDictation

A simple dictation tool that uses OpenAI's Whisper model for real-time speech-to-text transcription. Hold Ctrl+Alt to record your voice, and release to automatically transcribe and paste the text.

## Features

- Real-time voice recording with Ctrl+Alt hotkey
- Automatic transcription using Whisper AI
- System tray integration
- Automatic clipboard paste of transcribed text
- Support for English language

## Requirements

- Python 3.7+
- Required Python packages (see requirements.txt)
- A microphone for audio input

## Installation

1. Clone this repository:
```bash
git clone [repository-url]
cd WhisperDictation
```

2. Install the required packages:
```bash
pip install -r requirements.txt
```

## Usage

1. Run the application:
```bash
python dictation_app.py
```

2. Look for the microphone icon in your system tray
3. Hold Ctrl+Alt to start recording
4. Release Ctrl+Alt to stop recording and transcribe
5. The transcribed text will be automatically pasted at your cursor position

## License

MIT License

## Acknowledgments

This project uses OpenAI's Whisper model for speech recognition. 
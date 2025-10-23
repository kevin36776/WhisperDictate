import os
import time
import threading
import keyboard
import pyaudio
import wave
import numpy as np
import pyperclip
import whisper
import pystray
from PIL import Image, ImageDraw
from pynput import mouse
import tempfile

model = whisper.load_model("base.en")

recording = False
audio_frames = []
CHUNK = 1024
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 16000
p = pyaudio.PyAudio()
# Right-click + closest thumb button trigger the same recording behavior as Ctrl+Alt.
MOUSE_TRIGGER_BUTTONS = {mouse.Button.right, mouse.Button.x1}
pressed_mouse_buttons = set()
mouse_listener = None

def create_icon():
    image = Image.new('RGB', (64, 64), color = (255, 255, 255))
    dc = ImageDraw.Draw(image)
    dc.rectangle((20, 20, 44, 50), fill=(0, 0, 0))
    dc.rectangle((27, 10, 37, 20), fill=(0, 0, 0))
    dc.rectangle((20, 50, 44, 54), fill=(0, 0, 0))
    return image

def start_recording():
    global recording, audio_frames
    if not recording:
        audio_frames = []
        recording = True
        threading.Thread(target=record_audio).start()
        print("Recording started...")

def stop_recording():
    global recording
    if recording:
        recording = False
        print("Recording stopped, transcribing...")
        
        time.sleep(0.5)
        
        if audio_frames:
            temp_file = tempfile.NamedTemporaryFile(suffix='.wav', delete=False)
            temp_file_name = temp_file.name
            temp_file.close()
            
            with wave.open(temp_file_name, 'wb') as wf:
                wf.setnchannels(CHANNELS)
                wf.setsampwidth(p.get_sample_size(FORMAT))
                wf.setframerate(RATE)
                wf.writeframes(b''.join(audio_frames))
            
            result = model.transcribe(temp_file_name)
            text = result["text"].strip()
            
            pyperclip.copy(text)
            
            os.unlink(temp_file_name)
            
            print(f"Transcribed: {text}")
            
            keyboard.press_and_release('ctrl+v')

def record_audio():
    stream = p.open(format=FORMAT,
                   channels=CHANNELS,
                   rate=RATE,
                   input=True,
                   frames_per_buffer=CHUNK)
    
    global recording, audio_frames
    while recording:
        data = stream.read(CHUNK)
        audio_frames.append(data)
    
    stream.stop_stream()
    stream.close()

def on_exit(icon):
    global mouse_listener
    icon.stop()
    if mouse_listener is not None:
        mouse_listener.stop()
    p.terminate()
    os._exit(0)

def check_ctrl_alt(e):
    return keyboard.is_pressed('ctrl') and keyboard.is_pressed('alt')

def on_hotkey(e):
    if e.event_type == keyboard.KEY_DOWN and check_ctrl_alt(e):
        start_recording()
    elif e.event_type == keyboard.KEY_UP and not check_ctrl_alt(e):
        stop_recording()

def mouse_combo_active():
    return MOUSE_TRIGGER_BUTTONS.issubset(pressed_mouse_buttons)

def on_mouse_event(x, y, button, pressed):
    if button not in MOUSE_TRIGGER_BUTTONS:
        return

    if pressed:
        pressed_mouse_buttons.add(button)
        if mouse_combo_active():
            start_recording()
    else:
        pressed_mouse_buttons.discard(button)
        if recording and not mouse_combo_active():
            stop_recording()

def main():
    global mouse_listener
    keyboard.hook(on_hotkey)
    mouse_listener = mouse.Listener(on_click=on_mouse_event)
    mouse_listener.start()

    icon = pystray.Icon("WhisperDictation")
    icon.icon = create_icon()
    icon.menu = pystray.Menu(
        pystray.MenuItem("Exit", on_exit)
    )
    icon.title = "Whisper Dictation"
    
    print("Whisper Dictation started! Hold Ctrl+Alt to record.")
    icon.run()

if __name__ == "__main__":
    main()

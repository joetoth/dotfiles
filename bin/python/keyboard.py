#!/usr/bin/python3
import os
from evdev import InputDevice, categorize, ecodes
dev = InputDevice('/dev/input/by-id/usb-Massdrop_KC60-event-kbd')
dev.grab()

for event in dev.read_loop():
  print(event)
  if event.type == ecodes.EV_KEY:
    key = categorize(event)
    print(key)
    if key.keystate == key.key_down:
      if key.keycode == 'KEY_ESC':
        os.system('echo Hello World')
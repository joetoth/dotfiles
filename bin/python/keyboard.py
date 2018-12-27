#!/usr/bin/python3
import os
import atexit
import evdev
from evdev import InputDevice, categorize, ecodes as e, UInput

kbd = InputDevice('/dev/input/event5')
atexit.register(kbd.ungrab)  # Don't forget to ungrab the keyboard on exit!
kbd.grab()

REMAP_TABLE = {
  e.KEY_H: e.KEY_LEFT,
  e.KEY_J: e.KEY_DOWN,
  e.KEY_K: e.KEY_UP,
  e.KEY_L: e.KEY_RIGHT,
  e.KEY_Y: e.KEY_HOME,
  e.KEY_N: e.KEY_END,
  e.KEY_U: e.KEY_PAGEUP,
  e.KEY_O: e.KEY_PAGEDOWN,
  e.KEY_1: e.KEY_F1,
  e.KEY_2: e.KEY_F2,
  e.KEY_3: e.KEY_F3,
  e.KEY_4: e.KEY_F4,
  e.KEY_5: e.KEY_F5,
  e.KEY_6: e.KEY_F6,
  e.KEY_7: e.KEY_F7,
  e.KEY_8: e.KEY_F8,
  e.KEY_9: e.KEY_F9,
  e.KEY_0: e.KEY_F10,
  e.KEY_MINUS: e.KEY_F11,
  e.KEY_EQUAL: e.KEY_F12,
  e.KEY_BACKSPACE: e.KEY_DELETE,
}
# The names can be found with evtest or in evdev docs.

esc = False
intercepted = False
# Create a new keyboard mimicking the original one.
with UInput.from_device(kbd, name='kbdremap') as ui:
  for ev in kbd.read_loop():  # Read events from original keyboard.
    if ev.type == e.EV_KEY:  # Process key events.
      # ke = evdev.categorize(ev)
      act = kbd.active_keys()
      # print(act)
      # print(ev.value)
      if e.KEY_ESC in act:
        esc = True
        for k, v in REMAP_TABLE.items():
          if k in act:
            intercepted = True
            ui.write(e.EV_KEY, v, 1)
            ui.write(e.EV_KEY, v, 0)
            ui.syn()
      elif esc and not intercepted:
        ui.write(e.EV_KEY, e.KEY_ESC, 1)
        ui.write(e.EV_KEY, e.KEY_ESC, 0)
        ui.syn()
        intercepted = False
        esc = False
      else:
        esc = False
        intercepted = False
        ui.write(ev.type, ev.code, ev.value)
        ui.syn()


#!/usr/bin/python3
import os
import atexit
import evdev
from evdev import InputDevice, categorize, ecodes as e, UInput

kbd = InputDevice('/dev/input/event9')
atexit.register(kbd.ungrab)  # Don't forget to ungrab the keyboard on exit!
kbd.grab()

REMAP_TABLE = {
  e.KEY_H: e.KEY_LEFT,
  e.KEY_J: e.KEY_DOWN,
  e.KEY_K: e.KEY_UP,
  e.KEY_L: e.KEY_RIGHT,
}
# The names can be found with evtest or in evdev docs.

# n = 10
# for event in kbd.read_loop():
#   print(event.type)
#   if event.type != e.EV_KEY:
#     continue
#   with UInput() as ui:
#     ui.write(e.EV_KEY, event.code, event.value)
#     print(event)
#   if n == 0:
#     break
#   n = n - 1
#   n = n - 1
soloing_caps = False
esc = False
# Create a new keyboard mimicking the original one.
with UInput.from_device(kbd, name='kbdremap') as ui:
  for ev in kbd.read_loop():  # Read events from original keyboard.
    intercepted = False
    if ev.type == e.EV_KEY:  # Process key events.
      ke = evdev.categorize(ev)

      act = kbd.active_keys()
      print(act)
      print(ev.value)
      if e.KEY_ESC in act:
        for k, v in REMAP_TABLE.items():
          esc = True
          if k in act:
            ui.write(e.EV_KEY, v, 1)
            ui.write(e.EV_KEY, v, 0)
            ui.syn()
            intercepted = True
    if not intercepted: ui.write(ev.type, ev.code, ev.value)

    # print(evdev.categorize(ev))
    # print(act)
    # if e.KEY_CAPSLOCK in act:
    #   if e.KEY_J in act:
    #     print(ev.value)
    #     ui.write(e.EV_KEY, e.KEY_DOWN, ev.value)

    # print('s', ev)
    # if ev.type == e.EV_KEY:  # Process key events.
    #   if soloing_caps:
    #     print('soloing')
    #     if ev.code == e.KEY_J:
    #       print('DOWN')
    #       ui.write(e.EV_KEY, e.KEY_DOWN, ev.value)
    #   elif ev.code == e.KEY_PAUSE and ev.value == 1:
    #     # Exit on pressing PAUSE.
    #     # Useful if that is your only keyboard. =)
    #     # Also if you bind that script to PAUSE, it'll be a toggle.
    #     break
    #   elif ev.code in REMAP_TABLE:
    #     # Lookup the key we want to press/release instead...
    #     remapped_code = REMAP_TABLE[ev.code]
    #     # And do it.
    #     ui.write(e.EV_KEY, remapped_code, ev.value)
    #     # Also, remap a 'solo CapsLock' into an Escape as promised.
    #     if ev.code == e.KEY_CAPSLOCK and ev.value == 0:
    #       if soloing_caps:
    #         # Single-press Escape.
    #         ui.write(e.EV_KEY, e.KEY_ESC, 1)
    #         ui.write(e.EV_KEY, e.KEY_ESC, 0)
    #   else:
    #     # Passthrough other key events unmodified.
    #     ui.write(e.EV_KEY, ev.code, ev.value)
    #   # If we just pressed (or held) CapsLock, remember it.
    #   # Other keys will reset this flag.
    #   soloing_caps = (ev.code == e.KEY_CAPSLOCK and ev.value)
    # else:
    #   # Passthrough other events unmodified (e.g. SYNs).
    #   ui.write(ev.type, ev.code, ev.value)
#
#
#
# n = 50
# for event in dev.read_loop():
#   if event.type != e.EV_KEY:
#     continue
#   with UInput() as ui:
#     # ui.write_event(event)
#     ui.write(e.EV_KEY, event.code, event.value)
#     ui.syn()
#   if n == 0:
#     break
#   n = n - 1
#
# # dev.ungrab()
#   # print(n)
# #   quit(0)
# # #  if event.type == ecodes.EV_KEY:
# # #    key = categorize(event)
# # #    print(key)
# # #    if key.keystate == key.key_down:
# # #      if key.keycode == 'KEY_ESC':
# # #        os.system('echo Hello World')

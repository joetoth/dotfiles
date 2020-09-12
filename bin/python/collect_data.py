import time
from pynput import keyboard

logs = list()

def on_release(key):
  on_press(key, 'R')

def on_press(key, action='P'):
  if isinstance(key, keyboard.Key):
    k = key.name
  else:
    k = key.char
  record = f'{k}|{time.time_ns()}|{action}\n'
  logs.append(record)
  if len(logs) % 250 == 0:
    print('Saving data...')
    with open(f'/Users/joetoth/projects/dotfiles/bin/python/logs/{time.time_ns()}', mode='w') as f:
      f.writelines(logs)
      logs.clear()



# collect events until released
with keyboard.Listener( on_press=on_press, on_release=on_release) as listener:
  listener.join()

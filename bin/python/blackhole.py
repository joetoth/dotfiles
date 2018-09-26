#!/usr/bin/python

from os.path import expanduser
import subprocess
import sys
import json
from subprocess import CalledProcessError, Popen, PIPE
#-p works with the PRIMARY selection. That's the middle click one.
#-s works with the SECONDARY selection. I don't know if this is used anymore.
#-b works with the CLIPBOARD selection. That's your Ctrl + V one.

def ipython(text):
  p = Popen(['xsel', '-bi'], stdin=PIPE)
  p.communicate(input=text)

  # Create pane with the following
  # tmux new -s ipython -n ipython
  cmd = ['tmux', 'send-keys', '-t', 'ipython:ipython', '%paste\n']
  try:
    subprocess.check_output(cmd)
  except CalledProcessError as e:
    log({'command': str(cmd), 'message': e.output})


def log(dct):
  with open(expanduser('~/blackhole.log'), 'a') as f:
    f.write(json.dumps(dct))


def main():
  if len(sys.argv) < 2:
    print('usage: blackhole.py json')
    sys.exit(1)

  log(sys.argv[1])
  d = json.loads(sys.argv[1])

  if d['context'] == 'intellij':
    ipython(d['text'])
  else:
    log({'message': 'No handler found', 'json': d})


if __name__ == '__main__':
  main()

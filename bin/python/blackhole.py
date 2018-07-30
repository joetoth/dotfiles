#!/usr/bin/python

from os.path import expanduser
import subprocess
import sys
import json
from subprocess import CalledProcessError


def ipython(text):
  text += '\n\n'
  cmd = ['tmux', 'send-keys', '-t', 'ipython:ipython', text]
  error = "command: " + str(cmd) + "\n"
  try:
    subprocess.check_output(cmd)
  except CalledProcessError as e:
    error += "error: " + e.output
    log(error)


def log(text):
  with open(expanduser('~/blackhole.log'), 'a') as f:
    f.write(text)


def main():
  if len(sys.argv) < 2:
    print('usage: blackhole.py json')
    sys.exit(1)

  log("json: " + sys.argv[1])
  d = json.loads(sys.argv[1])

  if d['context'] == 'intellij':
    ipython(d['text'])
  else:
    log('No handler found')


if __name__ == '__main__':
  main()

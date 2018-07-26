#!/usr/bin/python
import subprocess
import sys
import json
from subprocess import CalledProcessError


def ipython(text):
  cmd = ['tmux', 'send-keys', '-t', 'ipython:ipython', text]
  error = "command: " + str(cmd) + "\n"
  try:
    subprocess.check_output(cmd)
  except CalledProcessError as e:
    error += "error: " + e.output
    log(error)


def log(text):
  with open('/home/joetoth/blackhole.log', 'a') as f:
    f.write(text)


def main():
  if len(sys.argv) < 2:
    print('usage: blackhole.py json')
    sys.exit(1)

  log("json: " + sys.argv[1])
  d = json.loads(sys.argv[1])

  if d['context'] == 'intelllij':
    ipython(d['text'])


if __name__ == '__main__':
  main()

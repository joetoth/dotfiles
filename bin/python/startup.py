import os
from os.path import expanduser

# Add auto-completion and store history file of Python interpreter commands.
import atexit
import readline
import rlcompleter

history_path = os.path.expanduser("~/.pyhistory")

def save_history(history_path=history_path):
  import readline
  readline.write_history_file(history_path)

if os.path.exists(history_path):
  readline.read_history_file(history_path)

atexit.register(save_history)
del atexit, readline, rlcompleter, save_history, history_path


try:
  import sys
  print('adding thrifpy to path')
  print(sys.path)
  sys.path.insert(0,'/opt/clion-beta/plugins/python-ce/helpers/third_party/thriftpy')
  from _shaded_thriftpy.server import TServer
except Exception as e:
  print(e)


# Increase default pandas width.
try:
  import pandas
  pandas.set_option('display.max_rows', 10)
  pandas.set_option('display.max_columns', 500)
  pandas.set_option('display.max_colwidth', 200)
  pandas.set_option('display.width', 1000)
except Exception as e:
  print(e)

try:
  import tensorflow as tf
  import numpy as np
except Exception as e:
  print(e)

# Currently necessary for autoreload to work.
try:
  from google3.learning.deepmind.python.adhoc_import import binary_import
  binary_import.adhoc_import_modules("/google/src/cloud/joetoth/abe/google3", ['google3.learning.neurosurgeon', 'google3.experimental.users.joetoth'])
  print('auto import enabled for google3.learning.neurosurgeon')
except Exception as e:
  print(e)

# Auto reload
from IPython import get_ipython
ipython = get_ipython()
if ipython:
  ipython.magic("load_ext autoreload")
  ipython.magic("autoreload 2")
  print("autoreload enabled")
  ipython.magic("load_ext ipython_autoimport")
  # pip install ipython_autotimport
  print("ipython_autoimport enabled")


print('PYTHONSTARTUP LOADED', __file__)

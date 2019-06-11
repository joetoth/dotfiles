# Default modules.
#from __future__ import absolute_import
#from __future__ import division
#from __future__ import print_function
#
import os
from os.path import expanduser
import numpy as np
import pandas as pd
#import pyarrow as pa
import multiprocessing as mp
import tensorflow as tf
tf.enable_v2_behavior()
import apache_beam as beam
#import tensorflow.google as tf
# Auto reload modules

# currently necessary for autoreload to work
#from google3.research.colab.lib import googlefiles
#googlefiles.EnableGoogleFilesStat()
#googlefiles.EnableOpenGoogleFiles()

# Auto reload
from IPython import get_ipython
ipython = get_ipython()
if ipython:
  ipython.magic("load_ext autoreload")
  ipython.magic("autoreload 2")

  # ipython.magic("load_ext ipython_autoimport")
  # print('autoimport')
  # req: ipython-autoimport
  # ipython.config.InteractiveShellApp.exec_lines.append(
  #     "try:\n    %load_ext ipython_autoimport\nexcept ImportError: pass")


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



#import pandas
##pandas.set_option('display.height', 1000)
#pandas.set_option('display.max_rows', 10)
#pandas.set_option('display.max_columns', 500)
#pandas.set_option('display.max_colwidth', 200)
#pandas.set_option('display.width', 1000)


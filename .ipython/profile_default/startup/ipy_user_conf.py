# Default modules.
#from __future__ import absolute_import
#from __future__ import division
#from __future__ import print_function
#
import os
from os.path import expanduser
#import numpy as np
#import pandas as pd
#import pyarrow as pa
#import multiprocessing as mp
#import tensorflow as tf
#import tensorflow.google as tf
# Auto reload modules

# currently necessary for autoreload to work
#from google3.research.colab.lib import googlefiles
#googlefiles.EnableGoogleFilesStat()
#googlefiles.EnableOpenGoogleFiles()

# Auto reload
from IPython import get_ipython
ipython = get_ipython()
#ipython.magic("pylab")
ipython.magic("load_ext autoreload")
ipython.magic("autoreload 2")

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


# usual adhoc_import from CitC
#from google3.research.colab.public import adhoc_import
#adhoc_import.Initialize(
#    "/google/src/cloud/{}/{}/google3".format("joetoth", 'abe'),
#    verbose=True, behavior='preferred')
# python -c 'import time; start=time.time(); import edward as ed; print(time.time() - start)'

# vim: filetype=python



# Most of your config files and extensions will probably start
# with this import


#import pandas
##pandas.set_option('display.height', 1000)
#pandas.set_option('display.max_rows', 10)
#pandas.set_option('display.max_columns', 500)
#pandas.set_option('display.max_colwidth', 200)
#pandas.set_option('display.width', 1000)

import os

# some config helper functions you can use
def import_all(modules):
    """ Usage: import_all("os sys") """
    for m in modules.split():
        ip.ex("from %s import *" % m)

def execf(fname):
    """ Execute a file in user namespace """
    ip.ex('execfile("%s")' % os.path.expanduser(fname))
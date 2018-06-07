#! /usr/bin/python
"""
Print tfrecords. Assumes GZIP.
Pass a number as an argument to print that many records otherwise if none
given just print the number of records in the file.
"""

import sys
import tensorflow as tf
from tensorflow.python.lib.io.tf_record import tf_record_iterator, TFRecordCompressionType, TFRecordOptions

f = sys.argv[1]
num = 0
if len(sys.argv) > 2:
    num = int(sys.argv[2])

#if not options:

options = TFRecordOptions(TFRecordCompressionType.GZIP)
record_iterator = tf_record_iterator(f, options=options)
size = 0
for string_record in record_iterator:
    example = tf.train.Example()
    example.ParseFromString(string_record)
    if num > 0:
      print(example)
    size += 1
    if size == num:
        break
if num == 0:
  print('size', size)

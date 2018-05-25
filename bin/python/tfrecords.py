import sys
import tensorflow as tf
from tensorflow.python.lib.io.tf_record import tf_record_iterator

f = sys.argv[1]
num = 1
if len(sys.argv) > 2:
    num = int(sys.argv[2])

  # if not options:
  #   options = TFRecordOptions(TFRecordCompressionType.ZLIB)
record_iterator = tf_record_iterator(f)
size = 0
for string_record in record_iterator:
    example = tf.train.Example()
    example.ParseFromString(string_record)
    print(example)
    size += 1
    if size == num:
        break

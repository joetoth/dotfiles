import os.path
import sys
import pyinotify
import time
from shutil import copyfile


class FileModifyWatcher(object):

  def __init__(self, file_list):
    self.watch_dirs = set([os.path.dirname(f) for f in file_list])

  def handle_event(self, event):
    if ".git" in event.pathname or "COPY" in event.pathname:
      print("Ignoring: " + event.pathname)
      return
    filename = os.path.basename(event.pathname)
    dst = sys.argv[2] + "/" + filename + ".COPY." + str(time.time())
    print "Copying: " + event.pathname + " to " + dst
    copyfile(event.pathname, dst)

  def loop(self):
    handle_event = self.handle_event

    class EventHandler(pyinotify.ProcessEvent):

      def process_default(self, event):
        handle_event(event)

    wm = pyinotify.WatchManager()  # Watch Manager
    mask = pyinotify.IN_CLOSE_WRITE
    ev = EventHandler()
    notifier = pyinotify.Notifier(wm, ev)

    for watch_this in self.watch_dirs:
      print("watching: " + watch_this)
      wm.add_watch(watch_this, mask, rec=True)

    notifier.loop()


if __name__ == "__main__":
  d = sys.argv[1]
  fw = FileModifyWatcher([d])
  fw.loop()

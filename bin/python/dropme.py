#!/usr/bin/python

import gtk
import os
import sys

if len(sys.argv) < 2:
  print 'usage: dropme <path>'
  sys.exit(1)
paths = map(os.path.abspath, sys.argv[1:])

win = gtk.Window(gtk.WINDOW_POPUP)
targets = [('text/uri-list', 0, 0)]
win.drag_source_set(gtk.gdk.BUTTON1_MASK, targets, gtk.gdk.ACTION_COPY)


def drag_data_get_cb(widget, context, sel, info, time):
  sel.set_uris(map(lambda p: 'file://' + p, paths))


win.connect('drag-data-get', drag_data_get_cb)
win.connect('drag-end', lambda *args: gtk.main_quit())

image = gtk.Image()
image.set_from_stock(gtk.STOCK_FILE, gtk.ICON_SIZE_LARGE_TOOLBAR)
win.add(image)
win.show_all()
win.move(0, 0)  # just in case

gtk.main()

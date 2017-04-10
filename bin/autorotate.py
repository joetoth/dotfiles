#!/usr/bin/env python3.5
##############################################################################
# TODO:
# * create gnome dock w/ status, pause, and lock-rotation options
# * documentation
##############################################################################
from glob import glob
import logging
import os
import signal
from subprocess import check_call, check_output, Popen
import sys
from time import sleep
import traceback

# decide which messages to show
LOG_LEVEL = logging.DEBUG
# log output to a file (set to None to use stdout)
LOG_FILE = None
# the name of the display to rotate (None for default/everything)
OUTPUT = 'eDP1'
# which keyboards to disable when in tablet mode
KEYBOARDS = ('AT Translated Set 2 keyboard',)
# which pointing devices to disable when in tablet mode
POINTERS = ('ALPS PS/2 Device', 'AlpsPS/2 ALPS GlidePoint')
# touchscreens that require rotation when screen is rotated
TOUCHSCREENS = ('SYNAPTICS Synaptics Touch Digitizer V04',)
# how frequently to check sensor values for changes (in seconds)
POLL_INTERVAL = 1
# sensitivity to rotation (lower values = more sensitive)
GRAVITY_THRESHOLD = 2.0 # gravity trigger
# path to the various iio sensor directories
SENSORS_PATH = '/sys/bus/iio/devices/iio:device*'
# path to the lid switch sensor
LID_SENSOR_PATH = '/proc/acpi/button/lid/LID0/state'
# command to launch on-screen keyboard (in array form for Popen())
KEYBOARD_CMD = ['onboard']
# how many errors in a row will cause this daemon to give up and exit
ERROR_TOLERANCE = 8

ORIENTATIONS = {
    'normal': {
        'pen': 'none',
        'transform_matrix': [1, 0, 0, 0, 1, 0, 0, 0, 1],
    },
    'inverted': {
        'pen': 'half',
        'transform_matrix': [-1, 0, 1, 0, -1, 1, 0, 0, 1],
    },
    'left': {
        'pen': 'ccw',
        'transform_matrix': [0, -1, 1, 1, 0, 0, 0, 0, 1],
    },
    'right': {
        'pen': 'cw',
        'transform_matrix': [0, 1, 0, -1, 0, 1, 0, 0, 1],
    },
}

class AutoRotate():
    env = None
    output = None
    keyboards = None
    pointers = None
    accel_base_dir = None
    incl_base_dir = None
    mode = None
    orientation = None
    keyboard_pid = None
    stopping = False
    _input_devices = None

    def __init__(self,
                 output=OUTPUT,
                 keyboards=KEYBOARDS,
                 pointers=POINTERS,
                 touchscreens=TOUCHSCREENS):
        # set up standard logging
        logging.basicConfig(filename=LOG_FILE, level=LOG_LEVEL)

        # access to env (for making external calls)
        self.env = os.environ.copy()

        # access to various parameters
        self.output = output
        # weed out any input devices that aren't actually available
        self.keyboards = self.verify_input_devices(keyboards)
        self.pointers = self.verify_input_devices(pointers)
        self.touchscreens = self.verify_input_devices(touchscreens)

        # always attempt to exit cleanly
        signal.signal(signal.SIGINT, self.stop)
        signal.signal(signal.SIGTERM, self.stop)

    def stop(self, *args, **kwargs):
        logging.info('Signal Received: exiting cleanly')
        # revert back to laptop mode and restore all functionality
        if self.mode != 'laptop':
            self.mode = 'laptop'
            self.set_mode(self.mode)
        # revert back to normal orientation
        if self.orientation != 'normal':
            self.orientation = 'normal'
            self.set_orientation(self.orientation)
        # kill on-screen keyboard if it's still running
        self.kill_keyboard()
        # set an instance flag to tell the daemon to shut down
        self.stopping = True

    def _get_sensor_base_dirs(self):
        for path in glob(SENSORS_PATH):
            with open(os.path.join(path, 'name')) as f:
                name = f.read()
                if 'accel' in name:
                    self.accel_base_dir = path
                elif 'incli' in name:
                    self.incl_base_dir = path
            if self.accel_base_dir and self.incl_base_dir:
                break;
        else:
            sys.stderr.write("Cannot find all sensor devices\n")
            sys.exit(1)


    @property
    def input_devices(self):
        if self._input_devices is None:
            # use xinput to create a list of all available input devices
            cmd = ['xinput', '--list', '--name-only']
            devices = check_output(cmd, env=self.env).splitlines()
            # conver to set so that we can easily compare collections
            self._input_devices = set(devices)
        return self._input_devices

    def verify_input_devices(self, devices):
        return tuple(set(devices) & self.input_devices)

    def read_sensor_file(self, base_dir, fname):
        with open(os.path.join(base_dir, fname), 'r') as f:
            return float(f.read())

    def is_lid_open(self):
        with open(LID_SENSOR_PATH) as f:
            return 'open' in f.read()

    def read_incl(self):
        if not self.incl_base_dir:
            self._get_sensor_base_dirs()
        base_dir = self.incl_base_dir
        # multiply by 10 for better granularity
        scale = self.read_sensor_file(base_dir, 'in_incli_scale') * 10
        x = self.read_sensor_file(base_dir, 'in_incli_x_raw') * scale
        y = self.read_sensor_file(base_dir, 'in_incli_y_raw') * scale
        z = self.read_sensor_file(base_dir, 'in_incli_z_raw') * scale
        return x, y, z
    
    def read_accel(self):
        if not self.accel_base_dir:
            self._get_sensor_base_dirs()
        base_dir = self.accel_base_dir
        scale = self.read_sensor_file(base_dir, 'in_accel_scale')
        x = self.read_sensor_file(base_dir, 'in_accel_x_raw') * scale
        y = self.read_sensor_file(base_dir, 'in_accel_y_raw') * scale
        return x, y

    def rotate_screen(self, orientation):
        os.system('xrandr --output %s --rotate %s' % (self.output, orientation))

    def get_mode(self):
        x, y, z = self.read_incl()
        # always assume laptop mode if lid is closed
        if not self.is_lid_open() or ((18 > x > 9) and (4 > y > -5)):
            return 'laptop'
        return 'tablet'

    def set_mode(self, mode):
        """
        i.e. laptop or tablet
        """
        logging.info('set mode: %s', mode)
        fn = 'disable' if mode == 'tablet' else 'enable'
        # disable keyboard and pointers (other than touchscreen)
        for keyboard in self.keyboards:
            check_call(['xinput', fn, 'keyboard:%s' % keyboard], env=self.env)
        for pointer in self.pointers:
            check_call(['xinput', fn, 'pointer:%s' % pointer], env=self.env)
        # show/hide onscreen keyboard
        if mode == 'tablet':
            self.launch_keyboard()
        else:
            self.kill_keyboard()

    def get_orientation(self):
        x, y = self.read_accel()
        # use the axis with the highest offset
        if abs(x) > abs(y):
            if x <= -GRAVITY_THRESHOLD:
                return 'right'
            if x >= GRAVITY_THRESHOLD:
                return 'left'
        else:
            if y <= -GRAVITY_THRESHOLD:
                return 'normal'
            if y >= GRAVITY_THRESHOLD:
                return 'inverted'
        # if thresholds not exceeded, stay where we are
        return self.orientation

    def set_orientation(self, orientation):
        logging.info("set orientation: %s", orientation)
        # rotate the screen
        check_call([
                       'xrandr',
                       '--output',
                       self.output,
                       '--rotate',
                       orientation
                   ],
                   env=self.env)
        # set tranformation matrix coords for the touchscreen(s) (i.e. rotate)
        matrix = ORIENTATIONS[orientation]['transform_matrix']
        for ts in self.touchscreens:
            check_call([
                           'xinput',
                           'set-prop',
                           ts,
                           'Coordinate Transformation Matrix',
                       ] + [str(n) for n in matrix],
                       env=self.env)

    def launch_keyboard(self):
       if self.keyboard_pid is None:
           self.keyboard_pid = Popen(KEYBOARD_CMD, env=self.env).pid
       return self.keyboard_pid

    def kill_keyboard(self):
        if self.keyboard_pid:
            os.system('kill %s' % self.keyboard_pid)
            self.keyboard_pid = None

    def run(self):
        logging.info('Launching Auto Rotate Daemon')
        errors_in_a_row = 0
        while not self.stopping:
            try:
                logging.debug("[Lid Open: %s]"
                              "[Incl X: %s, Y: %s, Z: %s]"
                              "[Accel X: %s, Y: %s]",
                              self.is_lid_open(),
                              *(self.read_incl() + self.read_accel()))
                #sleep(0.5)
                #continue
                mode = self.get_mode()
                if mode != self.mode:
                    self.mode = mode
                    self.set_mode(self.mode)

                orientation = 'normal'
                if mode == 'tablet':
                    orientation = self.get_orientation()
                if orientation != self.orientation:
                    self.orientation = orientation
                    self.set_orientation(self.orientation)
                sleep(POLL_INTERVAL)
                errors_in_a_row = 0
            except Exception as e:
                errors_in_a_row += 1
                logging.error('Unhandled Exception %d: %r\n%s',
                              errors_in_a_row,
                              e,
                              traceback.format_exc())
                if errors_in_a_row > ERROR_TOLERANCE:
                    logging.info('Error tolerance exceeded: shutting down')
                    self.stop()


if __name__ == '__main__':
    auto_rotate = AutoRotate()
    auto_rotate.run()

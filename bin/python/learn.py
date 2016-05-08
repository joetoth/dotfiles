import argparse
import datetime
import ConfigParser
import os
import tempfile

from subprocess import call
from time import sleep

from peewee import MySQLDatabase, Model, CharField, DateTimeField, TextField, IntegerField

EDITOR = os.environ.get('EDITOR', 'vim')
INTERVAL_SECONDS = 60 * 15

parser = argparse.ArgumentParser()
parser.add_argument('--daemon', type=bool, default=False,
                    help='Start in daemon mode which notifies to rekall')
parser.add_argument('--concept', type=str,
                    help='Concept to store for rekall')
parser.add_argument('--rekall', type=bool, default=False,
                    help='Print text and increment rekall')
parser.add_argument('--remove', type=bool, default=False,
                    help='Remove a concept')
parser.add_argument('--printall', type=bool, default=False,
                    help='Print everything in the database')

config = ConfigParser.ConfigParser()
config.read(os.path.expanduser('~/.rekall'))

args = parser.parse_args()
db = MySQLDatabase("rekall", host=config.get("mysql", "host"), user=config.get("mysql", "user"), passwd=config.get("mysql", "password"), charset="utf8", use_unicode=True)
db.connect()

class BaseModel(Model):
  class Meta:
    database = db

class Concept(BaseModel):
  name = CharField()
  text = TextField(default="# Explanation / Analogy / Like I'm Five" )
  last_rekall = DateTimeField(default=datetime.datetime.now)
  rekalls = IntegerField(default=0)

  def next_rekall(self):
    return self.last_rekall + datetime.timedelta(seconds=(INTERVAL_SECONDS ^ self.rekalls))

Concept.create_table(fail_silently=True)

## START
if args.daemon:
  db.close()
  print("Starting Rekall Daemon...")

  while (True):
    db.connect()
    concept = None
    for c in Concept.select():
      if concept is None:
        if c.next_rekall() < datetime.datetime.now():
          concept = c
        continue
      concept = c if concept.next_rekall() > c.next_rekall() else concept
    if concept is not None:
      os.system('notify-send -t 10000 -u critical "REKALL\n' + concept.name + '"')
    db.close()
    sleep(INTERVAL_SECONDS)

if args.printall:
  for v in Concept.select():
    print("Name: " + v.name)
    print("Last Rekall: " + str(v.last_rekall))
    print("Rekalls: " + str(v.rekalls))
    print("Text: " + v.text)
    print("===========================")
  quit()

if args.concept is None:
    print("--concept required")
    quit()
concept_key = args.concept.lower()

if args.rekall:
  try:
    concept = Concept.get(Concept.name == concept_key)
    print("Rekalled: " + str(concept.rekalls))
    concept.rekalls += 1
    concept.last_rekall = datetime.datetime.now()
    concept.save()
  except Concept.DoesNotExist:
    print("Could not find concept")
  quit()

if args.remove:
  try:
    concept = Concept.get(Concept.name == concept_key)
    concept.delete_instance()
    print("Removed " + concept.name)
  except Concept.DoesNotExist:
    print("Could not find concept")
  quit()

try:
  concept = Concept.get(Concept.name == concept_key)
except Concept.DoesNotExist:
  concept = Concept()
  concept.name = args.concept

with tempfile.NamedTemporaryFile() as f:
  f.write(concept.text.encode('utf-8'))
  f.flush()
  call([EDITOR, f.name])
  f.seek(0)
  concept.text = f.read()
  concept.save()


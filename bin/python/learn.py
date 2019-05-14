import argparse
import datetime
import ConfigParser
import os
import tempfile

from subprocess import call
from time import sleep

# from peewee import MySQLDatabase, Model, CharField, DateTimeField, TextField, IntegerField
from absl import app
from absl import flags

import os
import sys
from sqlalchemy import Column, ForeignKey, Integer, String, TIMESTAMP
from sqlalchemy.exc import DatabaseError
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker, scoped_session
from sqlalchemy import create_engine

auto_session = []

class MyBase(object):

    def save(self):
        auto_session[0].add(self)
        self._flush()
        return self

    def update(self, **kwargs):
        for attr, value in kwargs.items():
            setattr(self, attr, value)
        return self.save()

    def delete(self):
        auto_session[0].delete(self)
        self._flush()

    def _flush(self):
        try:
            auto_session[0].flush()
        except DatabaseError:
            auto_session[0].rollback()
            raise

Base = declarative_base(cls=MyBase)
# Base.query = auto_session[0].query_property()

class Concept(Base):
  __tablename__ = 'concept'
  name = Column(String(250), nullable=False, primary_key=True)
  text = Column(String(250), nullable=False,
                server_default="# Explanation / Analogy / Like I'm Five")
  last_rekall = Column(TIMESTAMP(), nullable=False, server_default="NOW()")
  rekalls = Column(Integer(), nullable=False)

  def next_rekall(self):
    return self.last_rekall + datetime.timedelta(
      seconds=(INTERVAL_SECONDS ^ self.rekalls))


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


def main(args):
  # Create an engine that stores data in the local directory's
  # sqlalchemy_example.db file.
  #
  # Valid SQLite URL forms are:
  # sqlite:///:memory: (or, sqlite://)
  # sqlite:///relative/path/to/file.db
  # sqlite:////absolute/path/to/file.db
  engine = create_engine('sqlite:////tmp/tmp.db', echo=True)
  con = engine.connect()
  dir(con)
  auto_session.append(scoped_session(sessionmaker(autocommit=True, bind=engine)))


  # Create all tables in the engine. This is equivalent to "Create Table"
  # statements in raw SQL.
  Base.metadata.create_all(engine)
  c = Concept()
  c.name = "abc"
  c.text = "poo"
  c.rekalls = 0
  c.save()

  # Concept.create_table(fail_silently=True)

  ## START
  if args.daemon:
    engine.close()
    print("Starting Rekall Daemon...")

    while (True):
      engine.connect()
      concept = None
      for c in Concept.select():
        if concept is None:
          if c.next_rekall() < datetime.datetime.now():
            concept = c
          continue
        concept = c if concept.next_rekall() > c.next_rekall() else concept
      if concept is not None:
        os.system(
          'notify-send -t 10000 -u critical "REKALL\n' + concept.name + '"')
      engine.close()
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
    concept.name = "hello"

    # create session
Session = sessionmaker()
Session.configure(bind=engine)
session = Session()

data = {'a': 5566, 'b': 9527, 'c': 183}
try:
    for _key, _val in data.items():
        row = TestTable(key=_key, val=_val)
        session.add(row)
    session.commit()
except SQLAlchemyError as e:
    print(e)
finally:
    session.close()

    concept.
    concept.name = args.concept

  with tempfile.NamedTemporaryFile() as f:
    f.write(concept.text.encode('utf-8'))
    f.flush()
    call([EDITOR, f.name])
    f.seek(0)
    concept.text = f.read()
    concept.save()


if __name__ == '__main__':
  app.run(main)

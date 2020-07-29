import datetime
import os
import tempfile

from subprocess import call
from time import sleep

# from peewee import MySQLDatabase, Model, CharField, DateTimeField, TextField, IntegerField
from absl import app
from absl import flags

import os
import sys
from sqlalchemy import func, Column, ForeignKey, Integer, String, TIMESTAMP
from sqlalchemy.exc import DatabaseError
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker, scoped_session
from sqlalchemy import create_engine


FLAGS = flags.FLAGS

flags.DEFINE_boolean('daemon', False, 'Start in daemon mode which notifies rekall.')
flags.DEFINE_string('concept', None, 'Concept to store for rekall.')
flags.DEFINE_string('rekall', None, 'Print concept and increment.')
flags.DEFINE_boolean('remove', False, 'Remove a concept.')
flags.DEFINE_boolean('printall', False, 'Print everything in the database.')

EDITOR = os.environ.get('EDITOR', 'vim')
INTERVAL_SECONDS = 60 * 15

auto_session = []

#class MyBase(object):
#
#    def save(self):
#        auto_session[0].add(self)
#        self._flush()
#        return self
#
#    def update(self, **kwargs):
#        for attr, value in kwargs.items():
#            setattr(self, attr, value)
#        return self.save()
#
#    def delete(self):
#        auto_session[0].delete(self)
#        self._flush()
#
#    def _flush(self):
#        try:
#            auto_session[0].flush()
#        except DatabaseError:
#            auto_session[0].rollback()
#            raise

from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()
# Base.query = auto_session[0].query_property()

class Concept(Base):
  __tablename__ = 'concept'
  name = Column(String(250), nullable=False, primary_key=True)
  text = Column(String(250), nullable=False,
                server_default="# Explanation / Analogy / Like I'm Five")
  last_rekall = Column(TIMESTAMP(), nullable=False, default=func.now())
  rekalls = Column(Integer(), nullable=False)

  def next_rekall(self):
    return self.last_rekall + datetime.timedelta(
      seconds=(INTERVAL_SECONDS ^ self.rekalls))



#config = ConfigParser.ConfigParser()
#config.read(os.path.expanduser('~/.rekall'))

def main(_):
  # Create an engine that stores data in the local directory's
  # sqlalchemy_example.db file.
  #
  # Valid SQLite URL forms are:
  # sqlite:///:memory: (or, sqlite://)
  # sqlite:///relative/path/to/file.db
  # sqlite:////absolute/path/to/file.db
  engine = create_engine('sqlite:////tmp/tmp.db', echo=True)
  con = engine.connect()
  #auto_session.append(scoped_session(sessionmaker(autocommit=True, bind=engine)))

  # Create all tables in the engine. This is equivalent to "Create Table"
  # statements in raw SQL.
  Base.metadata.create_all(engine)

  ## START
  if FLAGS.daemon:
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

  if FLAGS.printall:
    for v in Concept.select():
      print("Name: " + v.name)
      print("Last Rekall: " + str(v.last_rekall))
      print("Rekalls: " + str(v.rekalls))
      print("Text: " + v.text)
      print("===========================")
    quit()

  if FLAGS.concept is None:
    print("--concept required")
    quit()
  concept_key = FLAGS.concept.lower()

  if FLAGS.rekall:
    try:
      concept = Concept.get(Concept.name == concept_key)
      print("Rekalled: " + str(concept.rekalls))
      concept.rekalls += 1
      concept.last_rekall = datetime.datetime.now()
      concept.save()
    except Concept.DoesNotExist:
      print("Could not find concept")
    quit()

  if FLAGS.remove:
    try:
      concept = session.query(Concept.name).filter(User.name == concept_key).one_or_none()
      concept = Concept.get(Concept.name == concept_key)
      concept.delete_instance()
      print("Removed " + concept.name)
    except Concept.DoesNotExist:
      print("Could not find concept")
    quit()

  # create session
  Session = sessionmaker()
  Session.configure(bind=engine)
  session = Session()
  concept = session.query(Concept).filter(Concept.name == concept_key).one_or_none()
  if concept is None:
    concept = Concept()
    session.add(concept)
    concept.name = FLAGS.concept
    concept.text = '# Explanation / Analogy / Like I''m Five'
    concept.rekalls = 0
  
  with tempfile.NamedTemporaryFile() as f:
    f.write(concept.text.encode('utf-8'))
    f.flush()
    call([EDITOR, f.name])
    f.seek(0)
    text = f.read()
    print('ccccc')
    print(text)
    concept.text = text
  session.commit()


if __name__ == '__main__':
  app.run(main)

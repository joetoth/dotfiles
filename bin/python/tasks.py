from os.path import expanduser

import pickle
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/tasks.readonly']

tasks_conf = expanduser('~/projects/psycho/config/tasks.json')


def main():
  """Shows basic usage of the Tasks API.
  Prints the title and ID of the first 10 task lists.
  """
  creds = None
  # The file token.pickle stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  if os.path.exists('token.pickle'):
    with open('token.pickle', 'rb') as token:
      creds = pickle.load(token)
  # If there are no (valid) credentials available, let the user log in.
  if not creds or not creds.valid:
    if creds and creds.expired and creds.refresh_token:
      creds.refresh(Request())
    else:
      flow = InstalledAppFlow.from_client_secrets_file(
        tasks_conf, SCOPES)
      creds = flow.run_local_server(port=0)
      # Save the credentials for the next run
      with open('token.pickle', 'wb') as token:
        pickle.dump(creds, token)

  service = build('tasks', 'v1', credentials=creds)
  dir(service)
  dir(service.tasks)
  # Call the Tasks API
  results = service.tasklists().list(maxResults=10).execute()
  items = results.get('items', [])
  print(items)
  print(items[0]['id'])
  a = service.tasks()
  tasks = a.list(tasklist=items[0]['id'], maxResults=10).execute()
  print(tasks)

  if not items:
    print('No task lists found.')
  else:
    print('Task lists:')
    for item in items:
      print(u'{0} ({1})'.format(item['title'], item['id']))


if __name__ == '__main__':
  main()

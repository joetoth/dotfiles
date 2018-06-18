from optparse import OptionParser
import os.path
import re

regex = re.compile(("([a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`"
                    "{|}~-]+)*(@|\sat\s)(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?(\.|"
                    "\sdot\s))+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)"))

def file_to_str(filename):
    """Returns the contents of filename as a string."""
    with open(filename) as f:
        return f.read().lower() # Case is lowered to prevent regex mismatches.

def get_emails(s, username_only):
    """Returns an iterator of matched emails found in string s."""
    return (email[0][:email[0].index("@")] if username_only else email[0] for email in re.findall(regex, s))

parser = OptionParser(usage="Usage: python %prog [FILE]...")

parser.add_option(
    '-u', '--username_only',
    dest='username_only',
    default=False,
    help='Only extract usernames instead of whole email')
options, args = parser.parse_args()

if not args:
    parser.print_usage()
    exit(1)

for arg in args:
    if os.path.isfile(arg):
        for email in get_emails(file_to_str(arg), options.username_only):
            print email
    else:
        print '"{}" is not a file.'.format(arg)
        parser.print_usage()

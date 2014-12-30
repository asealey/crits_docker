#!/bin/bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
user=''
email=''

usage () {
  echo "Usage:
  -u: User to create (Required)
  -e: Email to specify for user (Required)"
}

while getopts ":h?u:e:" opt; do
  case "$opt" in
    h|\?)
    usage
    exit 0
    ;;
    u)  user=$OPTARG;;
    e)  email=$OPTARG
  esac
done

shift $((OPTIND-1))

#[ "$1" = "--" ] && shift

if [ -z "$user" ] || [ -z "$email" ]
  then
  usage
  >&2 echo "Both User (-u) and Email (-e) are required"
  exit 1
fi

echo "Creating user=$user, email='$email'"

# Create collection in mongo
cd /data/crits
python manage.py create_default_collections

# Create user
python manage.py users -a -A -u $user -e $email

echo done

#!/bin/bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
initialize=false

usage () {
  echo "Usage:
  -i: Initialize mongo container (Default false)"
}

while getopts ":h?iu:e:" opt; do
  case "$opt" in
    h|\?)
    usage
    exit 0
    ;;
    i)  initialize=true;;
    u)  user=$OPTARG;;
    e)  email=$OPTARG
  esac
done

shift $((OPTIND-1))

# Verify user/email specified if initializing
if $initialize && ( [ -z "$user" ] || [ -z "$email" ] )
  then
  usage
  >&2 echo "Both User (-u) and Email (-e) are required when initializing"
  exit 1
fi


# Start the crits_mongo server
echo "Starting crits_mongo"
docker rm crits_mongo &>/dev/null; docker run -d -h crits_mongo --name crits_mongo -v /data/db:/data/db -t crits_mongo

# Initialize, if specified
if $initialize
  then
  echo "Spinning initializer container for $user/$email"
  sleep 5 # Required to prevent spinning from happening before mongo is ready.  Not sure why the mongo container doesn't validate that
  docker run --link crits_mongo:crits_mongo -t crits_web /data/crits/initializeMongo.sh -u $user -e $email
  echo "Done initializing"
fi


# Start the crits_web server
echo "Starting crits_web"
docker rm crits_web &>/dev/null ; docker run -d -p 1443:443 -h crits.example.com --name crits_web --link crits_mongo:crits_mongo -t crits_web

echo "Done"

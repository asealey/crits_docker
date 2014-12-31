#!/bin/bash

# Start the crits_mongo server
echo "Starting crits_mongo"
docker rm crits_mongo &>/dev/null; docker run -d -h crits_mongo --name crits_mongo -v /data/db:/data/db -t crits_mongo

# Start the crits_web server
echo "Starting crits_web"
docker rm crits_web &>/dev/null ; docker run -d -p 1443:443 -h crits.example.com --name crits_web --link crits_mongo:crits_mongo -t crits_web

echo "Done"

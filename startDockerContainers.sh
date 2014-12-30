#!/bin/bash

# Start the crits_mongo server
echo "Starting crits_mongo"
docker rm crits_mongo && docker run -d --name crits_mongo -v /data/db:/data/db -t crits_mongo

# Start the crits_web server
echo "Starting crits_web"
docker rm crits_web && docker run -d -P --name crits_web --link crits_mongo:crits_mongo -t crits_web

echo "Done"

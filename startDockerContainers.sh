#!/bin/bash

# Start the crits_mongo server
docker rm crits_mongo && docker run -d --name crits_mongo -t crits_mongo

# Start the crits_web server
docker rm crits_web && docker run -d -P --name crits_web --link crits_mongo:crits_mongo -t crits_web

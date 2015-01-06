#!/bin/bash

echo "Spinning initializer container for $user/$email"
sleep 5 # Required to prevent spinning from happening before mongo is ready.  Not sure why the mongo container doesn't validate that
docker run --entrypoint=/bin/bash --link crits_mongo_1:crits_mongo -t crits_web /data/crits/initializeMongo.sh $@
#docker run --link crits_mongo:crits_mongo -t crits_web /data/crits/initializeMongo.sh -u $user -e $email
echo "Done initializing"

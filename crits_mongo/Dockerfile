#
# Crits_Mongo Dockerfile
# (Based on standard Docker provided Dockerfile)
# https://github.com/dockerfile/mongodb
#

# Pull base image.
FROM dockerfile/mongodb
MAINTAINER Adam Sealey <asealey@gmail.com>

# Set CRITs specified params for mongo
RUN echo 0 > /proc/sys/vm/zone_reclaim_mode

# Define default command.
CMD ["mongod","--fork","--logpath /var/log/mongodb.log","--logappend"]

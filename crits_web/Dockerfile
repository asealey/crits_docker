# Dockerfile for Crits

FROM ubuntu:precise
MAINTAINER Adam Sealey <asealey@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C

# Install Updates
RUN apt-get update && apt-get install -y \
  curl \
  git \
  sudo \
  wget \
  vim


########## Install CRITs dependencies ##############
RUN cd /tmp && \
  # The asealey fork has an updated version of ssdeep which is required for successful build
  #git clone https://github.com/asealey/crits_dependencies.git && \

  # Using direct zip instead of git clone
  curl -SL https://github.com/asealey/crits_dependencies/archive/master.tar.gz | tar -xzC /tmp
RUN cd /tmp/crits_dependencies-master && \
  ./install_dependencies.sh

# Extra dependencies which seem to be missed
COPY install_extra_deps.sh /tmp/
RUN /bin/bash /tmp/install_extra_deps.sh

# Clean up
RUN rm -fr /tmp/*


# Tweak TCP Server params
# Not working because of Read-only filesystem
# Known issue: https://github.com/docker/docker/issues/4717, https://github.com/docker/docker/issues/5703
# Parameters should be set at the host level
#RUN echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
#RUN echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle

########### Setting up codebase ###########
RUN adduser crits && \
  mkdir -p /data/crits && \
  cd /data && \
  git clone https://github.com/asealey/crits.git && \
  cd /data/crits && \
  chgrp -R crits logs && \
  touch logs/crits.log && \
  chmod 664 logs/crits.log

# Setup the mongo config
COPY config/database.py /data/crits/crits/config/

# Create default collections in mongo
# Can't run this command, because not connected to the Mongo container yet
#RUN cd /data/crits && python manage.py create_default_collections

########## Setup Apache ###########
RUN apt-get install -y apache2 && \
  /etc/init.d/apache2 stop && \
  rm -rf /etc/apache2/sites-available/*

# Copy up apache configs
# TODO: Currently pulls straight from github, because relative path wasn't working
#       There is probably a better way
#ADD https://raw.githubusercontent.com/asealey/crits/master/extras/apache2.conf /etc/apache2/
#ADD https://raw.githubusercontent.com/asealey/crits/master/extras/sites-available/default https://raw.githubusercontent.com/asealey/crits/master/extras/sites-available/default-ssl /etc/apache2/sites-available/
COPY extras/*.conf /etc/apache2/
COPY extras/sites-available/ /etc/apache2/sites-available/

# Link in the necessary site configs
RUN rm /etc/apache2/sites-enabled/* && \
  ln -s /etc/apache2/sites-available/default-ssl /etc/apache2/sites-enabled/default-ssl

# Generate temp cert
RUN cd /tmp && \
  #openssl req -new > new.cert.csr && \
  #openssl rsa -in privkey.pem -out new.cert.key && \
  openssl req -nodes -newkey rsa:2048 -keyout new.cert.key -out new.cert.csr -subj "/C=US/ST=Oregon/L=Beaverton/O=Security/OU=Security/CN=crits.example.com" && \
  openssl x509 -in new.cert.csr -out new.cert.cert -req -signkey new.cert.key -days 1825 && \
  cp new.cert.cert /etc/ssl/certs/crits.crt && \
  cp new.cert.key /etc/ssl/private/crits.plain.key && \
  a2enmod ssl && \
  echo "export LANG=en_US.UTF-8" >> /etc/apache2/envvars

# Start up apache
RUN /etc/init.d/apache2 restart

VOLUME ["/data/crits"]

EXPOSE 80
EXPOSE 443

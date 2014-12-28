# Dockerfile for Crits

FROM ubuntu:precise
MAINTAINER Adam Sealey <asealey@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install Updates
RUN apt-get update && apt-get install -y \
  curl \
  git \
  sudo \
  wget \
  vim


########## Install CRITs dependencies ##############
RUN cd /tmp && \
  git clone https://github.com/crits/crits_dependencies.git && \
  cd crits_dependencies && \
  ./install_dependencies.sh

# Tweak TCP Server params
RUN echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
RUN echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle

########### Setting up codebase ###########
RUN adduser crits && \
  mkdir -p /data/crits && \
  cd /data && \
  git clone https://github.com/asealey/crits.git && \
  cd /data/crits && \
  chgrp -R crits logs && \
  touch logs/crits.log && \
  chmod 664 logs/crits.log




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


# Installing the codebase
RUN adduser crits

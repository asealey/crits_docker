# Dockerfile for Crits

FROM ubuntu:precise
MAINTAINER Adam Sealey (asealey@gmail.com)

ENV DEBIAN_FRONTEND noninteractive

# Install curl
RUN apt-get update && apt-get upgrade && apt-get install -y apt-utils curl wget


### CRITs Salt Method ###
# Provision salt
ADD http://bootstrap.saltstack.com/ /tmp/install_salt.sh
RUN sh /tmp/install_salt.sh -X -M ; [ -f /usr/bin/salt-minion ] && echo 'salt-minion and salt-master appear to be installed. The "Failed to run install_ubuntu_check_services" error can likely be ignored as it is a limitation of the script for docker containers (see https://github.com/saltstack/salt-bootstrap/issues/394)'
# Copy in the salt configs (lazier than mounting, because it doesn't change?)
ADD salt/roots/salt /srv/salt
# Link minion.conf to minion, since salt doesn't care about the .conf extension
RUN ln -s /srv/salt/minion.conf /srv/salt/minion
# Salt configs via volume
#VOLUME ['/srv/salt']

#RUN curl 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x4759FA960E27C0A6' | apt-key add -

# Execute the salt configuration
RUN salt-call --local state.highstate -l debug --config-dir=/srv/salt

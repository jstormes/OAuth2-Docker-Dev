#!/bin/bash

set -e

############################################################################
# set host.docker.internal if it is not set
############################################################################
if ! ping -c 1 host.docker.internal &> /dev/null
then
  ip -4 route list match 0/0 | awk '{print $3 " host.docker.internal"}' >> /etc/hosts
fi

############################################################################
# Set execute permissions for tools
############################################################################
chmod a+x /var/www/bin/*
chmod a+x /root/bin/*

############################################################################
# Install Composer Packages if they are not installed
############################################################################
if [[ ! -d "/var/www/vendor" ]]
then
    cd /var/www
    composer install
    composer development-enable
fi

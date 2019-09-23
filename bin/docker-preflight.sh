#!/bin/bash

set -e

SCRIPT=$(readlink -f "$0")

echo "############################################################################################################"
echo "# Starting $SCRIPT"
echo "############################################################################################################"

apt-get update -y &> /dev/null

############################################################################
# Install composer if not found
############################################################################
if ! which composer &> /dev/null
then
    echo "Installing Composer"
    apt-get install -y wget git
    wget https://getcomposer.org/installer
    php installer
    rm installer
    mv composer.phar /usr/local/bin/composer
    chmod u+x /usr/local/bin/composer
fi

############################################################################
# Setup XDebug, always try and start XDebug connection to requesting ip
# DO NOT DO THIS ON PUBLICLY ACCESSIBLE SYSTEMS!!!!!!!
############################################################################
if [[ ! $(find /usr/local/lib/php/extensions/ -name xdebug.so) ]];
then
    echo "Installing XDEBUG"
    yes | pecl install xdebug
    echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.remote_connect_back=on"  >> /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.idekey=default-docker" >> /usr/local/etc/php/conf.d/xdebug.ini
    echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini
fi

############################################################################
# set host.docker.internal if it is not set
############################################################################
apt-get install -y inetutils-ping iproute2 &> /dev/null
if ! ping -c 1 -W 1 "host.docker.internal"; then
  echo "Adding host host.docker.internal"
  ip -4 route list match 0/0 | awk '{print $3 " host.docker.internal"}' >> /etc/hosts
  ping -c 1 -W 1 "host.docker.internal"
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
    echo "Installing Composer packages"
    cd /var/www
    composer install
    composer development-enable
fi

echo "############################################################################################################"
echo "# Exit $SCRIPT"
echo "############################################################################################################"

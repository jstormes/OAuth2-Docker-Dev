FROM php:7-apache

############################################################################
# Install requried libraries, should be the same across dev, QA, etc...
############################################################################
RUN apt-get -y update \
    && apt-get install -y curl zip unzip libpng-dev libzip-dev \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && yes '' | pecl install -f redis \
       && rm -rf /tmp/pear \
       && docker-php-ext-enable redis \
    && docker-php-ext-install gd zip

############################################################################
# Configure webserver
############################################################################
RUN a2enmod rewrite

############################################################################
# Install composer and other tools
############################################################################
RUN apt-get -y update \
    && apt-get install -y wget git \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && wget https://getcomposer.org/installer \
    && php installer \
    && rm installer \
    && mv composer.phar /usr/local/bin/composer \
    && chmod u+x /usr/local/bin/composer
# Add our script files so they can be found
ENV PATH /var/www/vendor/bin:/var/www/bin:/root/bin:~/.composer/vendor/bin:$PATH

############################################################################
# Setup XDebug, always try and start XDebug connection to requesting ip
############################################################################
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=on"  >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.idekey=oauth2docker" >> /usr/local/etc/php/conf.d/xdebug.ini

############################################################################
# Add preflight to apache2-foreground
############################################################################
# [ -f /tmp/filename.pid ] || python daemon.py restart
RUN sed -i '3i[[ -f /root/bin/docker-preflight.sh ]] && bash /root/bin/docker-preflight.sh' /usr/local/bin/apache2-foreground
RUN sed -i '4i[[ -f /var/www/bin/docker-preflight.sh ]] && bash /var/www/bin/docker-preflight.sh' /usr/local/bin/apache2-foreground


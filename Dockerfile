FROM php:7-apache

############################################################################
# Install requried libraries, should be the same across dev, QA, etc...
############################################################################
RUN apt-get -y update \
    && apt-get install -y curl wget git zip unzip libpng-dev libzip-dev \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && yes '' | pecl install -f redis \
       && rm -rf /tmp/pear \
       && docker-php-ext-enable redis \
    && docker-php-ext-install gd zip

############################################################################
# Configure local webserver
############################################################################
RUN a2enmod rewrite

############################################################################
# Install composer enable tools in path
############################################################################
RUN cd /root \
    && mkdir bin \
    && cd bin \
    && wget https://getcomposer.org/installer \
    && php installer \
    && rm installer \
    && mv composer.phar composer \
    && chmod u+x composer
# Add our script files so they can be found
ENV PATH /var/www/bin:/root/bin:~/.composer/vendor/bin:$PATH

#############################################################################
# Set permissions
#############################################################################
#RUN chown -R www-data:www-data /var/www/data
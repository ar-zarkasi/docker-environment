FROM php:5.6.40-fpm-alpine

ARG user
ARG uid

RUN apk add git iputils nano curl

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && apk del .build-deps $PHPIZE_DEPS \
    && chmod uga+x /usr/local/bin/install-php-extensions && sync \
    && install-php-extensions bcmath \
            bz2 \
            calendar \
            exif \
            gd \
            gettext \
            imagick \
            imap \
            intl \
            mcrypt \
            memcached \
            mysqli \
            pdo_mysql \
            pgsql \
            pdo_pgsql \
            sockets \
            sysvsem \
            sysvshm \
            xmlrpc \
            xsl \
            zip \
    &&  echo -e "\n xdebug.remote_enable=1 \n xdebug.remote_host=localhost \n xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    &&  echo -e "\n xhprof.output_dir='/var/tmp/xhprof'" >> /usr/local/etc/php/conf.d/docker-php-ext-xhprof.ini \
    && cd ~
# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Install msmtp - To Send Mails on Production & Development
RUN apk add msmtp

# modify www-data user to have id 1000
RUN adduser -G root -G www-data -u $uid -h /home/$user -D $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:www-data /home/$user

WORKDIR ${DOCKER_PATH}
RUN chown -R $user:www-data ${DOCKER_PATH}

USER $user
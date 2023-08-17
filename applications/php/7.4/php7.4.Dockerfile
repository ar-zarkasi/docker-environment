FROM php:7.4.32-fpm-alpine

ARG user
ARG uid

RUN apk add git iputils nano curl

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && apk --no-cache add --update zstd-dev \
    && apk del .build-deps $PHPIZE_DEPS \
    && chmod uga+x /usr/local/bin/install-php-extensions && sync
RUN install-php-extensions bcmath \
            bz2 \
            calendar \
            exif \
            gd \
            gettext
RUN install-php-extensions imap intl
RUN install-php-extensions imagick
RUN install-php-extensions mcrypt
RUN install-php-extensions memcached
RUN install-php-extensions mongodb
RUN install-php-extensions mysqli
RUN install-php-extensions openssl
RUN install-php-extensions pdo
RUN install-php-extensions pdo_mysql
RUN install-php-extensions pgsql
RUN install-php-extensions pdo_pgsql
RUN install-php-extensions redis
RUN install-php-extensions enchant
RUN install-php-extensions sockets
RUN install-php-extensions sysvsem
RUN install-php-extensions sysvshm
RUN install-php-extensions reflection
RUN install-php-extensions pcntl
RUN install-php-extensions pcre
RUN install-php-extensions msgpack
RUN install-php-extensions ctype
RUN install-php-extensions phar
RUN install-php-extensions posix
RUN install-php-extensions pspell
RUN install-php-extensions soap
RUN install-php-extensions sqlite3
RUN install-php-extensions tokenizer
RUN install-php-extensions xsl
RUN install-php-extensions zip
RUN install-php-extensions xml
RUN install-php-extensions xmlreader
RUN install-php-extensions xmlwriter
RUN install-php-extensions xmlrpc
RUN echo -e "\n xdebug.remote_enable=1 \n xdebug.remote_host=localhost \n xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    &&  echo -e "\n xhprof.output_dir='/var/tmp/xhprof'" >> /usr/local/etc/php/conf.d/docker-php-ext-xhprof.ini \
    && cd ~
# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Install msmtp - To Send Mails on Production & Development
RUN apk add msmtp

# Install Supervisor
RUN apk add supervisor

# RUN echo "[supervisorctl]" >> /etc/supervisor/
RUN apk add sudo

RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

# modify www-data user to have id 1000
RUN adduser -G root -G www-data -u $uid -h /home/$user -D $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:www-data /home/$user
RUN adduser $user wheel
RUN sed -e 's;^# \(%wheel.*NOPASSWD.*\);\1;g' -i /etc/sudoers
RUN echo "$user ALL = NOPASSWD:ALL" >> /etc/sudoers

RUN chown -R $user:www-data /var/www/html
RUN mkdir  /var/www/logs && \
    chown -R $user:www-data /var/www/logs

# RUN /usr/bin/supervisord -s -d /var/www/logs -c /etc/supervisor.d/worker.ini -j /var/www/logs/worker.pid
WORKDIR ${APP_WORKING_DIR}
USER $user

# CMD ["/usr/bin/supervisord","-n", "-c", "/etc/supervisor.d/worker.ini" ]
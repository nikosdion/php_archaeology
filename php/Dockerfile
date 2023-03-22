ARG PHP_VERSION=""
FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

RUN apk update; \
    apk upgrade;

RUN curl -s -O https://curl.haxx.se/ca/cacert.pem && mv cacert.pem /usr/local/share/ca-certificates && update-ca-certificates

RUN docker-php-ext-install -j12 mysqli

COPY php.ini /usr/local/etc/php/conf.d/php.ini
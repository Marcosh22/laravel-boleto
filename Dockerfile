FROM php:8.3-fpm-alpine

RUN apk add --no-cache \
  openssl \
  bash \
  unzip \
  vim \
  $PHPIZE_DEPS \
  libzip-dev \
  zlib-dev \
  libsodium-dev \
  icu-dev \
  icu-data-full \
  libpng-dev \
  linux-headers

RUN docker-php-ext-configure intl
RUN docker-php-ext-install zip sodium intl gd
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN docker-php-ext-enable zip sodium

# Configuração do Xdebug
RUN echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

EXPOSE 9000

ENTRYPOINT ["php-fpm"]

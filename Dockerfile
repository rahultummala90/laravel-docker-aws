
FROM php:8.0-apache


COPY --chown=www-data:www-data . /srv/app

COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf 

WORKDIR /srv/app

#RUN docker-php-ext-install mbstring pdo pdo_mysql \ 
#    && a2enmod rewrite negotiation \
#    && docker-php-ext-install opcache


RUN apt-get update && apt-get install -y  \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libwebp-dev \
    --no-install-recommends \
    && docker-php-ext-enable opcache \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql -j$(nproc) gd \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* 

RUN a2enmod rewrite headers 
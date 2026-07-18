
FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install intl pdo_mysql zip \
    && a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .
EXPOSE 80
RUN composer install --no-dev --optimize-autoloader


RUN chown -R www-data:www-data /var/www/html

ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

EXPOSE 80 RUN composer install --no-dev --optimize-autoloader
RUN composer install --no-dev --optimize-autoloader


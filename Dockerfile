FROM php:8.2-apache

# Տեղադրում ենք Symfony-ի extension-ները
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libzip-dev \
    && docker-php-ext-install intl zip pdo_mysql \
    && a2enmod rewrite

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Սա կստիպի Composer-ին մաքուր տեղադրել ֆայլերը
RUN composer install --no-dev --optimize-autoloader --no-scripts

EXPOSE 80
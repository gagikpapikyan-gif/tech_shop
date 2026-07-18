FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libzip-dev \
    && docker-php-ext-install intl zip pdo_mysql \
    && a2enmod rewrite

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# Ջնջում ենք հին lock ֆայլը սերվերից, որ Render-ը զրոյից հաշվարկի տարբերակները
RUN rm -f composer.lock

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Զրոյից թարմացնում ենք բոլոր փաթեթները PHP 8.2-ի համար
RUN composer update --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs

EXPOSE 80
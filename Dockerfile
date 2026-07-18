FROM php:8.2-apache

# Տեղադրում ենք անհրաժեշտ գրադարանները
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libzip-dev \
    && docker-php-ext-install intl zip pdo_mysql \
    && a2enmod rewrite

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# ԿԱՐԵՎՈՐ. Ստիպում ենք Composer-ին աշխատել PHP 8.2-ի կանոններով
RUN composer config platform.php 8.2.12

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Թարմացնում ենք symfony-ի գրադարանը հենց build-ի ժամանակ
RUN composer update symfony/http-foundation --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs

EXPOSE 80
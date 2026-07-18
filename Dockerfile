FROM php:8.3-apache

# Տեղադրում ենք միայն այն համակարգային գրադարանները, որոնք Composer-ին պետք են
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libicu-dev \
    libzip-dev \
    && docker-php-ext-install intl zip \
    && a2enmod rewrite

# Բերում ենք Composer-ը
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# Կարգավորում ենք Apache-ն
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Տեղադրում ենք բոլոր vendor-ները հանգիստ
RUN composer install --no-dev --optimize-autoloader --no-scripts

EXPOSE 80
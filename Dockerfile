FROM php:8.2-apache

# Տեղադրում ենք բոլոր հնարավոր extension-ները, որ Symfony-ն չբողոքի
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install intl zip pdo_mysql gd \
    && a2enmod rewrite

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# Ստեղծում ենք ժամանակավոր .env ֆայլ, եթե այն չկա, որ build-ը չկոտրվի
RUN test -f .env || echo "APP_ENV=prod" > .env

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Օգտագործում ենք --ignore-platform-reqs, որ անտեսի համակարգային անհամապատասխանությունները
RUN composer install --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs

EXPOSE 80
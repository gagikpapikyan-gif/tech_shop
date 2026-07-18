FROM php:8.2.12-apache

# Տեղադրում ենք համակարգային գործիքներն ու PHP extension-ները
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libicu-dev \
    libzip-dev \
    && docker-php-ext-install intl pdo_mysql zip \
    && a2enmod rewrite

# Բերում ենք Composer-ը
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Պատճենում ենք պրոյեկտի ֆայլերը
COPY . .

# Կարգավորում ենք Apache-ն, որ նայի public թղթապանակին
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Տեղադրում ենք գրադարանները
RUN composer install --no-dev --optimize-autoloader --no-scripts

EXPOSE 80
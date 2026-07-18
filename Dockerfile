FROM php:8.2.12-apache

# Տեղադրում ենք Symfony-ին անհրաժեշտ համակարգային գործիքներն ու extension-ները
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libicu-dev \
    libzip-dev \
    && docker-php-ext-install intl pdo_mysql zip \
    && a2enmod rewrite

# Բերում ենք Composer-ի վերջին տարբերակը
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Պատճենում ենք պրոյեկտի բոլոր ֆայլերը
COPY . .

# Կարգավորում ենք Apache-ն, որ այն նայի public թղթապանակին
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Տեղադրում ենք գրադարանները առանց սկրիպտների (որ Build-ը չկոտրվի)
RUN composer install --no-dev --optimize-autoloader --no-scripts

EXPOSE 80
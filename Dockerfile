FROM php:8.2-apache

# Տեղադրում ենք միայն ամենաանհրաժեշտը՝ առանց ավելորդ թարմացումների
RUN apt-get update && apt-get install -y git unzip zip libicu-dev \
    && docker-php-ext-install intl pdo_mysql \
    && a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Շրջանցում ենք բոլոր հնարավոր սկրիպտների ու պլատֆորմի սխալները
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs --no-scripts

EXPOSE 80

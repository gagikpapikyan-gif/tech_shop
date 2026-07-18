FROM php:8.3-apache

# Միացնում ենք Apache-ի rewrite մոդուլը
RUN a2enmod rewrite

# Բերում ենք Composer-ը
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# Կարգավորում ենք Apache-ն, որ նայի public թղթապանակին
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Տեղադրում ենք գրադարանները առանց սկրիպտների և ստուգումների
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs --no-scripts

EXPOSE 80
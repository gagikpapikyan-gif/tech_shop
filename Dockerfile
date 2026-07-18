FROM thecodingmachine/php:8.2-v4-apache

# Սա ավտոմատ կակտիվացնի Symfony-ին պետք եղած հիմնական extension-ները
ENV PHP_EXTENSION_INTL=1 \
    PHP_EXTENSION_GD=1 \
    PHP_EXTENSION_ZIP=1 \
    APACHE_DOCUMENT_ROOT=public

COPY --chown=docker:docker . /var/www/html

RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

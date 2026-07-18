FROM thecodingmachine/php:8.2-v4-apache

COPY --chown=docker:docker . /var/www/html

ENV APACHE_DOCUMENT_ROOT=public

RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

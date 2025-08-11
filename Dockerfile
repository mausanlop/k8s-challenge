FROM php:8.1-apache

# Extensión MySQLi
RUN docker-php-ext-install mysqli

# Copia tu app
COPY . /var/www/html/

# (opcional) permisos mínimos
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# Gunakan image PHP 7.4.16 dengan Apache
FROM php:7.4.16-apache

# Install ekstensi PHP yang diperlukan
RUN docker-php-ext-install pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy seluruh proyek ke dalam container
COPY . .

# Install dependencies proyek
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Konfigurasi Apache
RUN a2enmod rewrite
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]

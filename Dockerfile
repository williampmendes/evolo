FROM php:8.3-fpm

# Instalação de extensões necessárias
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    npm \
    && docker-php-ext-install pdo_pgsql

# Instalação do Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Diretório de trabalho
WORKDIR /var/www

# Copia o projeto
COPY . .

# Instalação das dependências PHP
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Instalação das dependências JS e build
RUN npm install && npm run build

# Permissões corretas
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]

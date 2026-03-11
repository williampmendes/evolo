FROM php:8.3-fpm

# Set working directory
WORKDIR /var/www

# Instalação de dependências do sistema e extensões PHP
# As extensões são baseadas nas necessárias para o projeto (ver install.sh)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    zip \
    npm \
    # Dependências para extensões PHP
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/* \
    # Instala as extensões PHP
    && docker-php-ext-install pdo_pgsql mbstring xml curl zip bcmath \
    # Configura e instala a extensão GD
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Instalação do Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Otimização de cache do Docker:
# Copia primeiro os arquivos de dependência, instala, e só depois copia o resto do código.
# Isso evita reinstalar tudo a cada mudança de código.

COPY composer.json composer.lock ./
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

COPY package.json package-lock.json ./
RUN npm install

# Copia o restante do código da aplicação
COPY . .

# Compila os assets de frontend
RUN npm run build

# Permissões corretas
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]

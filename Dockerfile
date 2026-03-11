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
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_pgsql pgsql mbstring xml curl zip bcmath \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Instalação do Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Otimização de cache do Docker:
# Copia primeiro os arquivos de dependência, instala, e só depois copia o resto do código.
# Isso evita reinstalar tudo a cada mudança de código.

COPY composer*.json ./

# Remove o composer.lock antigo para evitar conflitos de plataforma e garantir dependências compatíveis com o container
RUN rm -f composer.lock
RUN git config --global url."https://".insteadOf git://
RUN COMPOSER_MEMORY_LIMIT=-1 COMPOSER_ALLOW_SUPERUSER=1 composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev --no-scripts -v

COPY package*.json ./
RUN npm install

# Copia o restante do código da aplicação
COPY . .

# Gera o autoloader otimizado e executa os scripts (como package:discover) agora que o código existe
RUN composer dump-autoload --optimize

# Compila os assets de frontend
RUN npm run build

# Permissões corretas
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]

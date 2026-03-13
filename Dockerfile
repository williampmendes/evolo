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
    libicu-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_pgsql pgsql mbstring xml curl zip bcmath intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Instalação do Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Otimização de cache do Docker:
# Copia primeiro os arquivos de dependência, instala, e só depois copia o resto do código.
# Isso evita reinstalar tudo a cada mudança de código.

COPY composer*.json ./
RUN rm -f composer.lock || true
RUN git config --global url."https://".insteadOf git://
RUN COMPOSER_MEMORY_LIMIT=-1 COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_PROCESS_TIMEOUT=2000 composer update --no-interaction --prefer-dist --no-autoloader --no-dev --no-scripts --ignore-platform-reqs -v

COPY package*.json ./
RUN npm install

# Copia o restante do código da aplicação
COPY . .

# Gera o autoloader otimizado e executa os scripts (como package:discover) agora que o código existe
RUN composer dump-autoload --optimize --no-scripts

# Compila os assets de frontend
RUN npm run build || echo "⚠️ NPM Build falhou, mas continuando o deploy..."

# Permissões corretas
RUN mkdir -p /var/www/storage/framework/cache /var/www/storage/framework/sessions /var/www/storage/framework/views /var/www/storage/logs /var/www/bootstrap/cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]

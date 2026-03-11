#!/bin/bash

# Instalação LOCAL (ambiente real na máquina)
instalacao_local() {
    echo "🚀 Iniciando instalação LOCAL do Evolo"

    sudo apt update && sudo apt upgrade -y

    # Verifica se o pacote php8.3 existe, caso contrário adiciona o PPA (comum em Ubuntu/Debian)
    if ! apt-cache show php8.3 >/dev/null 2>&1; then
        sudo apt install -y software-properties-common
        sudo add-apt-repository ppa:ondrej/php -y
        sudo apt update
    fi

    echo "📦 Instalando PHP, Composer, Node.js, PostgreSQL, Apache2..."
    sudo apt install -y php8.3 php8.3-cli php8.3-pgsql php8.3-mbstring php8.3-xml php8.3-curl php8.3-zip php8.3-bcmath php8.3-gd composer nodejs npm postgresql apache2 libapache2-mod-php8.3 curl

    echo "🔧 Configurando PostgreSQL..."
    sudo -u postgres psql <<EOF
DO
\$do\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'evolo_user') THEN
      CREATE USER evolo_user WITH PASSWORD 'password';
   END IF;
END
\$do\$;
EOF
    # Cria o banco de dados apenas se ele não existir
    sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = 'evolo'" | grep -q 1 || sudo -u postgres psql -c "CREATE DATABASE evolo OWNER evolo_user;"

    echo "🔧 Configurando Apache2 VirtualHost..."
    PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    sudo tee /etc/apache2/sites-available/evolo.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName evolo.local
    DocumentRoot ${PROJECT_DIR}/public

    <Directory ${PROJECT_DIR}/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/evolo_error.log
    CustomLog \${APACHE_LOG_DIR}/evolo_access.log combined
</VirtualHost>
EOF

    sudo a2ensite evolo.conf
    sudo a2enmod rewrite
    if ! grep -q "evolo.local" /etc/hosts; then
        echo "127.0.0.1 evolo.local" | sudo tee -a /etc/hosts
    fi
    sudo systemctl restart apache2

    echo "📥 Instalando dependências do Laravel e Frontend..."
    composer install
    npm install
    npm run build

    echo "⚙️ Configurando ambiente Laravel..."
    cp -n .env.example .env # Usa -n para não sobrescrever se já existir
    php artisan key:generate

    sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=pgsql/' .env
    sed -i 's/^DB_DATABASE=.*/DB_DATABASE=evolo/' .env
    sed -i 's/^DB_USERNAME=.*/DB_USERNAME=evolo_user/' .env
    sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=password/' .env

    php artisan migrate --seed

    echo "🔑 Ajustando permissões de pastas (storage e cache)..."
    sudo chown -R www-data:www-data storage bootstrap/cache
    sudo chmod -R 775 storage bootstrap/cache

    echo "✅ Instalação LOCAL concluída! Acesse: http://evolo.local"
}

# Instalação via DOCKER (com rede e configuração interna)
instalacao_docker() {
    echo "🚀 Iniciando instalação via DOCKER do Evolo"

    if ! command -v docker >/dev/null 2>&1; then
        echo "❌ Docker não encontrado. Instale antes de continuar."
        exit 1
    fi

    # Detecta se usa 'docker compose' (v2) ou 'docker-compose' (v1)
    if docker compose version >/dev/null 2>&1; then
        DOCKER_COMPOSE_CMD="docker compose"
    elif command -v docker-compose >/dev/null 2>&1; then
        DOCKER_COMPOSE_CMD="docker-compose"
    else
        echo "❌ Docker Compose não encontrado. Instale antes de continuar."
        exit 1
    fi

    $DOCKER_COMPOSE_CMD up -d --build

    echo "⏳ Aguardando o banco de dados ficar pronto..."
    attempts=0
    max_attempts=12
    # Assumindo que o serviço do banco de dados no docker-compose.yml se chama 'db'
    while ! $DOCKER_COMPOSE_CMD exec -T db pg_isready -U evolo_user -d evolo -q 2>/dev/null; do
        if [ $attempts -ge $max_attempts ]; then
            echo "❌ O banco de dados não ficou pronto após 60 segundos."
            $DOCKER_COMPOSE_CMD logs db
            exit 1
        fi
        attempts=$((attempts+1))
        echo "Aguardando... (tentativa $attempts/$max_attempts)"
        sleep 5
    done

    echo "📥 Instalando dependências dentro do container..."
    # Assumindo que o serviço da aplicação no docker-compose.yml se chama 'app'
    $DOCKER_COMPOSE_CMD exec app composer install
    $DOCKER_COMPOSE_CMD exec app npm install
    $DOCKER_COMPOSE_CMD exec app npm run build

    echo "⚙️ Configurando Laravel dentro do container..."
    $DOCKER_COMPOSE_CMD exec app cp -n .env.example .env
    $DOCKER_COMPOSE_CMD exec app php artisan key:generate

    echo "🗂️ Executando migrations e seeders dentro do container..."
    $DOCKER_COMPOSE_CMD exec app php artisan migrate:fresh --seed

    echo "✅ Docker configurado! Acesse: http://localhost:8080"
}

# Menu interativo caso não passe parâmetro
mostrar_menu() {
    echo "🔧 Escolha o modo de instalação:"
    echo "1️⃣  Ambiente 100% Local (PHP + Apache + PostgreSQL)"
    echo "2️⃣  Ambiente via Docker (Containers + Rede Docker)"
    echo "0️⃣  Cancelar"
    read -p "Opção: " opcao

    case $opcao in
        1) instalacao_local ;;
        2) instalacao_docker ;;
        0) echo "❌ Instalação cancelada."; exit 0 ;;
        *) echo "❌ Opção inválida."; exit 1 ;;
    esac
}

# Execução conforme parâmetro ou menu
case $1 in
    1) instalacao_local ;;
    2) instalacao_docker ;;
    "") mostrar_menu ;;
    *) echo "❌ Parâmetro inválido. Use 1 (Local) ou 2 (Docker)."; exit 1 ;;
esac

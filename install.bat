@ECHO OFF
SETLOCAL

REM =================================================================
REM  Script de Instalação Automática para Windows (via Docker)
REM  Para o projeto Evolo
REM =================================================================
ECHO.
ECHO #################################################
ECHO #   Iniciando configuracao do ambiente Evolo    #
ECHO #   via Docker no Windows                     #
ECHO #################################################
ECHO.

REM --- Verificando se o Docker está em execução ---
ECHO.
ECHO [1/7] Verificando se o Docker esta em execucao...
docker ps >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO [ERRO] O Docker nao parece estar em execucao.
    ECHO Por favor, inicie o Docker Desktop e tente novamente.
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO Docker OK.

REM --- Detectando a versão do Docker Compose ---
SET DOCKER_COMPOSE_CMD=
docker compose version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    SET DOCKER_COMPOSE_CMD=docker compose
) ELSE (
    docker-compose version >nul 2>&1
    IF %ERRORLEVEL% EQU 0 (
        SET DOCKER_COMPOSE_CMD=docker-compose
    )
)

IF "%DOCKER_COMPOSE_CMD%"=="" (
    ECHO.
    ECHO [ERRO] Nao foi possivel encontrar 'docker compose' ou 'docker-compose'.
    ECHO Verifique se o Docker Desktop esta instalado e atualizado.
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO Usando o comando: %DOCKER_COMPOSE_CMD%
ECHO.

REM --- Subindo os containers ---
ECHO.
ECHO [2/7] Construindo e iniciando os containers Docker...
%DOCKER_COMPOSE_CMD% up -d --build
IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO [ERRO] Falha ao subir os containers. Verifique a saida acima.
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO.

REM --- Aguardando o banco de dados ---
ECHO.
ECHO [3/7] Aguardando o banco de dados (PostgreSQL) ficar pronto... (aprox. 20 segundos)
timeout /t 20 /nobreak >nul
ECHO.

REM --- Instalando dependências do Composer ---
ECHO.
ECHO [4/7] Instalando dependencias do PHP com o Composer...
%DOCKER_COMPOSE_CMD% exec app composer install
IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO [ERRO] Falha ao instalar dependencias do Composer.
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO.

REM --- Instalando dependências do NPM e compilando assets ---
ECHO.
ECHO [5/7] Instalando dependencias do Node.js e compilando assets...
%DOCKER_COMPOSE_CMD% exec app npm install
%DOCKER_COMPOSE_CMD% exec app npm run build
IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO [ERRO] Falha ao executar os comandos NPM.
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO.

REM --- Configurando o ambiente Laravel ---
ECHO.
ECHO [6/7] Configurando o arquivo de ambiente (.env) e a chave do Laravel...
%DOCKER_COMPOSE_CMD% exec app cp -n .env.example .env
%DOCKER_COMPOSE_CMD% exec app php artisan key:generate
ECHO.

REM --- Executando as migrations e seeders ---
ECHO.
ECHO [7/7] Executando as migrations e populando o banco de dados...
%DOCKER_COMPOSE_CMD% exec app php artisan migrate:fresh --seed
IF %ERRORLEVEL% NEQ 0 (
    ECHO.
    ECHO [ERRO] Falha ao executar as migrations. Verifique se o banco de dados esta acessivel.
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO.

REM --- Finalização ---
ECHO.
ECHO #################################################
ECHO #                                               #
ECHO #   ^<ACENTO CIRCUNFLEXO>^ Configuracao concluida com sucesso!      #
ECHO #                                               #
ECHO #################################################
ECHO.
ECHO O projeto esta disponivel em: http://localhost:8080
ECHO.
ECHO Para parar os containers, execute: %DOCKER_COMPOSE_CMD% down
ECHO.

PAUSE
ENDLOCAL
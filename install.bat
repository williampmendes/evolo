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
ECHO [1/5] Verificando se o Docker esta em execucao...
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
ECHO [2/5] Construindo e iniciando os containers Docker (isso pode levar alguns minutos)...
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
ECHO [3/5] Aguardando o banco de dados (PostgreSQL) ficar pronto...
SET "ATTEMPTS=0"
SET "MAX_ATTEMPTS=12"

:DB_WAIT_LOOP
%DOCKER_COMPOSE_CMD% exec -T db pg_isready -U evolo_user -d evolo -q >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO Banco de dados pronto.
    GOTO :DB_READY
)

SET /A ATTEMPTS+=1
IF %ATTEMPTS% GEQ %MAX_ATTEMPTS% (
    ECHO.
    ECHO [ERRO] O banco de dados nao ficou pronto apos 60 segundos.
    ECHO Verificando logs do container 'db':
    %DOCKER_COMPOSE_CMD% logs db
    PAUSE
    EXIT /B 1
)

ECHO Aguardando... (tentativa %ATTEMPTS%/%MAX_ATTEMPTS%)
timeout /t 5 /nobreak >nul
GOTO :DB_WAIT_LOOP

:DB_READY
ECHO.

REM --- Configurando o ambiente Laravel ---
ECHO.
ECHO [4/5] Configurando o arquivo de ambiente (.env) e a chave do Laravel...
%DOCKER_COMPOSE_CMD% exec app cp -n .env.example .env
%DOCKER_COMPOSE_CMD% exec app php artisan key:generate
ECHO.

REM --- Executando as migrations e seeders ---
ECHO.
ECHO [5/5] Executando as migrations e populando o banco de dados...
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
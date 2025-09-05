.PHONY: help local docker migrate seed down logs

help:
	@echo "Comandos disponíveis:"
	@echo " make local      - Instalar e iniciar o projeto em ambiente local"
	@echo " make docker     - Subir projeto via Docker"
	@echo " make migrate    - Executar migrations e seeders (Docker ou Local)"
	@echo " make down       - Parar containers Docker"
	@echo " make logs       - Visualizar logs dos containers Docker"

local:
	@./install.sh 1

docker:
	@./install.sh 2

migrate:
	@if docker ps | grep evolo_app; then \
		docker exec -it evolo_app php artisan migrate:fresh --seed; \
	else \
		php artisan migrate:fresh --seed; \
	fi

down:
	@docker-compose down

logs:
	@docker-compose logs -f

DOCKER = docker compose
DOCKER_FILE = ./srcs/docker-compose.yml

re: down clean up

up:
	sudo mkdir -p /inception/data
	sudo mkdir -p /inception/data/wp
	sudo mkdir -p /inception/data/db
	sudo -S chmod -R 777 /inception/data
	sudo ${DOCKER} -f ${DOCKER_FILE} up --build -d

down:
	sudo ${DOCKER} -f ${DOCKER_FILE} down

clean:
	sudo ${DOCKER} -f ${DOCKER_FILE} down -v
	sudo rm -rf /inception/data/wp
	sudo rm -rf /inception/data/db

fclean: clean
	sudo docker system prune -af

.PHONY: up down clean fclean re
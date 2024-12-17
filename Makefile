DOCKER = docker compose
DOCKER_FILE = ./srcs/docker-compose.yml

re: down up

ps:
	docker ps -a

up:
	${DOCKER} -f ${DOCKER_FILE} up --build -d

down:
	${DOCKER} -f ${DOCKER_FILE} down

clean:
	${DOCKER} -f ${DOCKER_FILE} down -v

fclean: clean
	docker system prune -af

.PHONY: up down clean fclean re ps 
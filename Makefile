DOCKER = docker compose
DOCKER_FILE = ./srcs/docker-compose.yml

re: down fclean up

up:
	mkdir -p /home/jmougel/data
	mkdir -p /home/jmougel/data/wp
	mkdir -p /home/jmougel/data/db
	sudo -S chmod -R 777 /home/jmougel/data
	${DOCKER} -f ${DOCKER_FILE} up --build -d

down:
	${DOCKER} -f ${DOCKER_FILE} down

clean:
	${DOCKER} -f ${DOCKER_FILE} down -v
	sudo rm -rf /home/jmougel/data/wp
	sudo rm -rf /home/jmougel/data/db

fclean: clean
	docker system prune -af

.PHONY: up down clean fclean re
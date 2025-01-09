DOCKER = docker compose
DOCKER_FILE = ./srcs/docker-compose.yml

re: down fclean up

up:
	mkdir -p /home/jmougel/data
	mkdir -p /home/jmougel/data/wp
	mkdir -p /home/jmougel/data/db
	sudo -S chmod -R 777 /home/jmougel/data
	${DOCKER} -f ${DOCKER_FILE} up --build

down:
	${DOCKER} -f ${DOCKER_FILE} down

clean:
	sudo rm -rf /home/jmougel/data/wp
	sudo rm -rf /home/jmougel/data/db
	${DOCKER} -f ${DOCKER_FILE} down -v

fclean: clean
	sudo rm -rf /home/jmougel/data/wp
	sudo rm -rf /home/jmougel/data/db
	docker system prune -af

.PHONY: up down clean fclean re
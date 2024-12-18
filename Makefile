DOCKER = docker compose
DOCKER_FILE = ./srcs/docker-compose.yml
PWD_CRED = /home/jmougel/Documents/inception/secrets

include $(PWD_CRED)/credentials.txt

re: down up

ps:
	docker ps -a

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

fclean: clean
	rm -rf /home/jmougel/data/wp
	rm -rf /home/jmougel/data/db
	rm -rf /home/jmougel/data
	docker system prune -af

.PHONY: up down clean fclean re ps
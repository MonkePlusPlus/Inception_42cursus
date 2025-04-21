
NAME=inception
DOCC=docker compose

all: create_vol build up

host:
	sudo sed -i 's|localhost|ptheo.42.fr|g' /etc/hosts


build:
	$(DOCC) -f ./srcs/docker-compose.yml build

rm_vol:
	sudo chown -R $(USER) /home/ptheo/data
	sudo chmod -R 777 /home/ptheo/data
	rm -rf /home/ptheo/data

create_vol:
	mkdir -p /home/ptheo/data/mysql
	mkdir -p /home/ptheo/data/html
	sudo chown -R $(USER) /home/ptheo/data
	sudo chmod -R 777 /home/ptheo/data

up:
	$(DOCC) -f ./srcs/docker-compose.yml up -d

start:
	$(DOCC) -f ./srcs/docker-compose.yml start

down:
	$(DOCC) -f ./srcs/docker-compose.yml down

remove:
	sudo chown -R $(USER) /home/ptheo/data
	sudo chmod -R 777 /home/ptheo/data
	rm -rf /home/ptheo/data
	docker volume prune -f
	docker volume rm srcs_wordpress
	docker volume rm srcs_mariadb
	docker container prune -f

re: remove delete build up

list:
	docker ps -a
	docker images -a

delete:
	cd srcs && docker-compose stop nginx
	cd srcs && docker-compose stop wordpress
	cd srcs && docker-compose stop mariadb
	docker system prune -a

logs:
	cd srcs && docker-compose logs mariadb wordpress nginx


.PHONY: hosts all install build up start down remove re list images delete

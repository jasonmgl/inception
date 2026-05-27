# Developer Documentation


[Back](./README_EN.md)

This document explains how to set up, build, launch, inspect, and maintain the Inception project as a developer.

## Project Layout

```text
.
|-- Makefile
|-- README.md
|-- USER_DOC.md
|-- DEV_DOC.md
|-- srcs
|   |-- docker-compose.yml
|   |-- .env.example
|   `-- requirements
|       |-- mariadb
|       |-- nginx
|       `-- wordpress
`-- bonus
    |-- Makefile
    `-- srcs
        |-- docker-compose.yml
        |-- .env.example
        `-- requirements
            |-- adminer
            |-- fail2ban
            |-- ftp
            |-- mariadb
            |-- nginx
            |-- redis
            `-- wordpress
```

The mandatory stack lives in `srcs`. The bonus stack lives in `bonus/srcs`.

## Prerequisites

Install:

- `make`
- `docker`
- `docker compose`
- `sudo`
- `curl`

The Makefiles use `sudo` because they create and remove data directories under `/inception/data` and run Docker commands.

## Host Configuration

Add local domains to `/etc/hosts`:

```text
127.0.0.1 jmougel.local
127.0.0.1 jmougel2.local
```

Use `jmougel.local` for WordPress and `jmougel2.local` for the bonus static site.

## Environment Files And Secrets

Create the mandatory environment file:

```bash
cp srcs/.env.example srcs/.env
```

Create the bonus environment file:

```bash
cp bonus/srcs/.env.example bonus/srcs/.env
```

Mandatory variables:

```env
DOMAIN_NAME=jmougel.local
CERTIF_NAME=cert

MARIADB_PORT=3306
MARIADB_USER=user
MARIADB_HOST=mariadb
MARIADB_NAME=mariadb
MARIADB_USER_PASSWORD=user_password
MARIADB_ROOT_PASSWORD=root_password
```

Bonus variables add:

```env
DOMAIN_NAME2=jmougel2.local
CERTIF_NAME2=cert2
FTP_USER=ftp_user
FTP_PASS=ftp_password
```

Do not commit real `.env` files or real secrets. The `.env.example` files document the required keys.

## Build And Launch

Mandatory stack:

```bash
make up
```

The root Makefile runs:

```bash
sudo mkdir -p /inception/data
sudo mkdir -p /inception/data/wp
sudo mkdir -p /inception/data/db
sudo chmod -R 777 /inception/data
sudo docker compose -f ./srcs/docker-compose.yml up --build -d
```

Bonus stack:

```bash
cd bonus
make up
```

The bonus Makefile uses:

```bash
sudo docker compose -f ./srcs/docker-compose.yml up --build --timeout 300 -d
```

## Makefile Commands

| Command | Description |
| --- | --- |
| `make up` | Start or rebuild the stack. |
| `make down` | Stop containers without deleting persistent data. |
| `make re` | Delete project volumes and `/inception/data`, then rebuild. |
| `make clean` | Stop containers and delete project volumes plus project data. |
| `make fclean` | Run `clean` and prune unused Docker resources globally. |

Use `fclean` carefully because `docker system prune -af` affects Docker resources beyond this project.

## Docker Compose Commands

Render and validate Compose configuration:

```bash
docker compose -f srcs/docker-compose.yml config
docker compose -f bonus/srcs/docker-compose.yml config
```

List containers:

```bash
sudo docker compose -f srcs/docker-compose.yml ps
sudo docker compose -f bonus/srcs/docker-compose.yml ps
```

Build images without starting containers:

```bash
sudo docker compose -f srcs/docker-compose.yml build
sudo docker compose -f bonus/srcs/docker-compose.yml build
```

Start in the foreground for debugging:

```bash
sudo docker compose -f srcs/docker-compose.yml up --build
sudo docker compose -f bonus/srcs/docker-compose.yml up --build
```

Stop and remove containers:

```bash
sudo docker compose -f srcs/docker-compose.yml down
sudo docker compose -f bonus/srcs/docker-compose.yml down
```

Stop and remove containers plus named volumes:

```bash
sudo docker compose -f srcs/docker-compose.yml down -v
sudo docker compose -f bonus/srcs/docker-compose.yml down -v
```

## Container Management

Inspect logs:

```bash
sudo docker logs nginx
sudo docker logs wordpress
sudo docker logs mariadb
```

Open a shell in a container:

```bash
sudo docker exec -it nginx bash
sudo docker exec -it wordpress bash
sudo docker exec -it mariadb bash
```

Check Docker networks:

```bash
sudo docker network ls
sudo docker network inspect srcs_docker-network
```

List project volumes:

```bash
sudo docker volume ls
```

Inspect a project volume:

```bash
sudo docker volume inspect srcs_wordpress
sudo docker volume inspect srcs_mariadb
```

## Data Storage And Persistence

The Compose files define named volumes backed by host bind mounts:

```text
srcs_wordpress -> /inception/data/wp
srcs_mariadb   -> /inception/data/db
```

WordPress files persist in:

```text
/inception/data/wp
```

MariaDB files persist in:

```text
/inception/data/db
```

`make down` keeps these directories. `make clean` and `make re` remove them.

The bonus FTP container mounts the WordPress volume at:

```text
/inception/ftp
```

That means files uploaded by FTP are stored in the same persistent WordPress volume.

## Service Responsibilities

### Nginx

Files:

```text
srcs/requirements/nginx
bonus/srcs/requirements/nginx
```

Responsibilities:

- Generate self-signed TLS certificates.
- Serve HTTPS traffic on port `443`.
- Forward PHP requests to `wordpress:9000`.
- In bonus, route `/adminer/` to `adminer:9000`.
- In bonus, serve the static site for `jmougel2.local`.

### WordPress

Files:

```text
srcs/requirements/wordpress
bonus/srcs/requirements/wordpress
```

Responsibilities:

- Run PHP-FPM on internal port `9000`.
- Download WordPress with WP-CLI.
- Move and patch `wp-config.php`.
- Generate WordPress salts.
- Install WordPress using values from `.env`.
- In bonus, configure Redis cache integration.

### MariaDB

Files:

```text
srcs/requirements/mariadb
bonus/srcs/requirements/mariadb
```

Responsibilities:

- Listen on internal port `3306`.
- Initialize the database directory if needed.
- Create the configured database and users.
- Store persistent database files in `/inception/data/db`.

### Bonus Services

- `redis`: cache backend for WordPress.
- `adminer`: database administration UI served through Nginx.
- `ftp`: vsftpd server mounted on the WordPress volume.
- `fail2ban`: monitors `/var/log/vsftpd/vsftpd.log`.

## Validation Checklist

Run syntax checks:

```bash
docker compose -f srcs/docker-compose.yml config
docker compose -f bonus/srcs/docker-compose.yml config
bash -n srcs/requirements/*/script/*.sh
bash -n bonus/srcs/requirements/*/script/*.sh
```

Check HTTP responses:

```bash
curl -kI https://jmougel.local
curl -kI https://jmougel.local/wp-admin/
curl -kI https://jmougel.local/adminer/
curl -kI https://jmougel2.local
```

Expected behavior:

- Compose config renders without errors.
- All expected containers are running.
- Nginx responds on `443`.
- WordPress can connect to MariaDB.
- Data remains after `make down` and `make up`.
- Data is recreated after `make clean` or `make re`.

## Troubleshooting

Gateway timeout from Nginx:

- Check `sudo docker logs wordpress`.
- Confirm PHP-FPM is running in the WordPress container.
- Confirm Nginx uses `fastcgi_pass wordpress:9000`.
- Confirm MariaDB is ready before WordPress installation runs.

Database connection errors:

- Check `MARIADB_HOST=mariadb`.
- Check the database name, user, and password in `.env`.
- Check `sudo docker logs mariadb`.
- Recreate persistent data if old credentials are still stored.

Domain does not resolve:

- Check `/etc/hosts`.
- Use `curl -kI https://jmougel.local` to bypass browser cache and certificate UI.

Port conflict:

- Check whether another service already uses port `443`.
- Stop that service or change the Compose port mapping for local testing.

Stale volume state:

- Run `make clean` or `make re`.
- Confirm `/inception/data/wp` and `/inception/data/db` were removed.

[Back](./README_EN.md)

# User Documentation


[Back](./README_EN.md)

This document explains how an end user or administrator can understand, start, stop, access, and check the Inception stack.

## Provided Services

The mandatory stack provides three services:

- **Nginx:** public HTTPS web server. It receives browser traffic on port `443` and forwards PHP requests to WordPress.
- **WordPress:** website application served by PHP-FPM on internal port `9000`.
- **MariaDB:** database server used by WordPress on internal port `3306`.

The bonus stack adds:

- **Redis:** cache service used by WordPress.
- **Adminer:** browser-based database administration panel.
- **FTP:** file access to the WordPress volume.
- **Fail2ban:** monitors FTP logs and bans repeated failed attempts.
- **Static site:** second website served by Nginx on `jmougel2.local`.

Only Nginx and FTP expose public host ports. The other services stay inside the Docker network.

## Start The Project

Start the mandatory stack from the repository root:

```bash
make up
```

Start the bonus stack:

```bash
cd bonus
make up
```

The Makefile creates the persistent data directories under `/inception/data`, builds the images, and starts the containers in the background.

## Stop The Project

Stop the running containers while keeping the stored data:

```bash
make down
```

Rebuild everything from a clean project data directory:

```bash
make re
```

Remove the project containers, Docker volumes, and `/inception/data` content:

```bash
make clean
```

Use `make fclean` only when you also want to prune unused Docker resources globally:

```bash
make fclean
```

## Access The Website

Before opening the website, make sure these entries exist in `/etc/hosts`:

```text
127.0.0.1 jmougel.local
127.0.0.1 jmougel2.local
```

Open WordPress:

```text
https://jmougel.local
```

Your browser may show a certificate warning. This is expected because the project generates a self-signed certificate.

## Access Administration Panels

WordPress admin panel:

```text
https://jmougel.local/wp-admin/
```

Bonus Adminer panel:

```text
https://jmougel.local/adminer/
```

Bonus static website:

```text
https://jmougel2.local
```

Bonus FTP service:

```text
ftp://jmougel.local
```

FTP uses ports `20`, `21`, and passive ports `65500-65515`.

## Locate And Manage Credentials

Credentials are stored in the `.env` file used by the stack.

Mandatory stack:

```text
srcs/.env
```

Bonus stack:

```text
bonus/srcs/.env
```

Main credential variables:

- `MARIADB_USER`: MariaDB user and WordPress author username.
- `MARIADB_USER_PASSWORD`: MariaDB user password and WordPress author password.
- `MARIADB_ROOT_PASSWORD`: MariaDB root password and WordPress admin password.
- `FTP_USER`: bonus FTP username.
- `FTP_PASS`: bonus FTP password.

Generated application credentials:

- **WordPress admin:** `jmougel` / `MARIADB_ROOT_PASSWORD`
- **WordPress author:** `MARIADB_USER` / `MARIADB_USER_PASSWORD`
- **MariaDB user:** `MARIADB_USER` / `MARIADB_USER_PASSWORD`
- **MariaDB root:** `root` / `MARIADB_ROOT_PASSWORD`
- **FTP bonus user:** `FTP_USER` / `FTP_PASS`

If credentials change after WordPress or MariaDB has already been initialized, use `make clean` or `make re` to remove old persistent data and rebuild from the new values.

## Check Service Status

Mandatory stack:

```bash
sudo docker compose -f srcs/docker-compose.yml ps
```

Bonus stack:

```bash
sudo docker compose -f bonus/srcs/docker-compose.yml ps
```

A healthy stack should show the expected containers running:

- `nginx`
- `wordpress`
- `mariadb`
- Bonus: `redis`, `adminer`, `ftp`, `fail2ban`

## Check Logs

Use logs to understand startup or access problems:

```bash
sudo docker logs nginx
sudo docker logs wordpress
sudo docker logs mariadb
```

Bonus logs:

```bash
sudo docker logs redis
sudo docker logs adminer
sudo docker logs ftp
sudo docker logs fail2ban
```

## Check Web Access

Test WordPress:

```bash
curl -kI https://jmougel.local
```

Test WordPress admin:

```bash
curl -kI https://jmougel.local/wp-admin/
```

Test bonus Adminer:

```bash
curl -kI https://jmougel.local/adminer/
```

Test bonus static site:

```bash
curl -kI https://jmougel2.local
```

## Common Problems

If the domain does not load:

- Check `/etc/hosts`.
- Check that Nginx is running.
- Check that port `443` is not already used by another service.

If the browser shows a certificate warning:

- This is normal for a self-signed local certificate.

If Nginx returns a gateway timeout:

- Check `sudo docker logs wordpress`.
- Check that the WordPress container is running.
- Check that PHP-FPM is listening on internal port `9000`.
- Check that MariaDB is running and reachable.

If WordPress cannot connect to the database:

- Check `srcs/.env` or `bonus/srcs/.env`.
- Check `MARIADB_HOST`, `MARIADB_NAME`, `MARIADB_USER`, and `MARIADB_USER_PASSWORD`.
- Check `sudo docker logs mariadb`.

If old credentials still work after editing `.env`:

- Persistent data already exists.
- Run `make re` to remove and recreate project data.

[Back](./README_EN.md)

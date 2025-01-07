#!/bin/bash

mkdir -p /run/mysqld

chmod 777 /run/mysqld

bash sleep 10

service mysql start

mysql -e "CREATE DATABASE IF NOT EXISTS '${MYSQL_HOST}';"
mysql -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_HOST}.* TO '${MYSQL_USER}'@'%';"
mysql -u${MYSQL_ROOT_USER} -p${MYSQL_ROOT_PASS} -e "ALTER USER '${MYSQL_ROOT_USER}'@'${MYSQL_HOST}' IDENTIFIED BY '${MYSQL_USER}';"
mysql -e "FLUSH PRIVILEGES;"
mysqladmin -u${MYSQL_ROOT_USER} -p${MYSQL_ROOT_PASS} shutdown

exec "$1"

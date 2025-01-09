#!/bin/bash

mkdir -p /run/mysqld

chown -R www-data:www-data /run/mysqld

mysql -e "CREATE DATABASE IF NOT EXISTS \'$DB_NAME\';"
mysql -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON \'$DB_NAME\'.* TO '$MYSQL_USER'@'%';"
mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASS" -e "FLUSH PRIVILEGES;"
mysqladmin -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASS" shutdown

exec "$@"

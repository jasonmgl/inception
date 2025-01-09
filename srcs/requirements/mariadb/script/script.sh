#!/bin/bash

mkdir -p /run/mysqld

# while ! mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -P "$DB_PORT" -e "SELECT 1;" > /dev/null 2>&1; do
#     continue;
# done

service mysqld start

chown -R www-data:www-data /run/mysqld

mysql -e "SET PASSWORD FOR 'root'@'mariadb' = PASSWORD('${DB_ROOT_PASS}');"
mysql -e "CREATE DATABASE IF NOT EXISTS \'${DB_NAME}\';"
mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"
mysqladmin -u"${DB_ROOT_USER}" -p"${DB_ROOT_PASS}" shutdown

exec "$@"

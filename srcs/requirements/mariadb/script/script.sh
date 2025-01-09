#!/bin/bash

mkdir -p /run/mysqld
chown -R www-data:www-data /run/mysqld

mysql --version

mysqld_safe &

sleep 15

# mysql -u ${DB_ROOT_USER} -e "SET PASSWORD FOR '${DB_ROOT_USER}'@'%' = PASSWORD('${DB_ROOT_PASS}');"
# mysql -u ${DB_ROOT_USER} -p"${DB_ROOT_PASS}" -e "ALTER USER 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASS}';"
# mysql -u ${DB_ROOT_USER} -p"${DB_ROOT_PASS}" -e "CREATE DATABASE IF NOT EXISTS \'${DB_NAME}\';"
# mysql -u ${DB_ROOT_USER} -p"${DB_ROOT_PASS}" -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
# mysql -u ${DB_ROOT_USER} -p"${DB_ROOT_PASS}" -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
# mysql -u ${DB_ROOT_USER} -p"${DB_ROOT_PASS}" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
# mysql -u ${DB_ROOT_USER} -p"${DB_ROOT_PASS}" -e "FLUSH PRIVILEGES;"

mysql -u root <<EOF

SET PASSWORD FOR 'root'@'%' = PASSWORD('${DB_ROOT_PASS}');
ALTER USER 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL ON wordpress.* TO '${DB_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${DB_ROOT_PASS}" shutdown

exec "$@"

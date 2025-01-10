#!/bin/bash

mysql --version

sed -i 's/= 127.0.0.1/= 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/basedir/port\t\t\t\t\t= 3306\nbasedir/' /etc/mysql/mariadb.conf.d/50-server.cnf

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld --user=mysql --bootstrap <<EOF
USE mysql;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${MARIADB_NAME}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_USER_PASSWORD}';
GRANT ALL ON \`${MARIADB_NAME}\`.* TO '${MARIADB_USER}'@'%';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

exec "$@"

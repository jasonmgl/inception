#!/bin/bash

mkdir -p /run/mysqld

chown mysql:mysql /run/mysqld

mysqld &

sleep 5

service mysql start

mysql -e "CREATE DATABASE IF NOT EXISTS 'name';"
mysql -e "CREATE USER 'jmougel'@'%' IDENTIFIED BY 'root';"
mysql -e "GRANT ALL PRIVILEGES ON name.* TO 'jmougel'@'%';"
mysql -uroot -proot -e "ALTER USER 'root'@'mariadb' IDENTIFIED BY 'root';"
mysql -e "FLUSH PRIVILEGES;"
mysqladmin -uroot -proot shutdown

exec "mysqld_safe"
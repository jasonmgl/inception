#!/bin/bash

mkdir -p /run/php

chown -R www-data:www-data /var/www/html

sed -i -e "s/database_name_here/$DB_NAME/g" /var/www/html/wp-config.php
sed -i -e "s/username_here/$MYSQL_USER/g" /var/www/html/wp-config.php
sed -i -e "s/password_here/$MYSQL_PASS/g" /var/www/html/wp-config.php
sed -i -e "s/localhost/$MYSQL_HOST/g" /var/www/html/wp-config.php

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=$DB_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASS --dbhost=$MYSQL_HOST --allow-root
./wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$MYSQL_ROOT_USER --admin_password=$MYSQL_ROOT_PASS \
    --admin_email=jmougel@student.42lyon.fr --allow-root

exec "$@"
#!/bin/bash

sleep 20

API_WP=$(curl https://api.wordpress.org/secret-key/1.1/salt/)

mkdir -p /run/php
chown -R www-data:www-data /run/php

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root

chown -R www-data:www-data /var/www/html

if [ ! -f "/var/www/html/wp-config.php" ]; then
    mv /wp-config.php /var/www/html/
    sed -i -e "s/database_name_here/$MARIADB_DATABASE/g" /var/www/html/wp-config.php
    sed -i -e "s/username_here/$MARIADB_USER/g" /var/www/html/wp-config.php
    sed -i -e "s/password_here/$MARIADB_PASSWORD/g" /var/www/html/wp-config.php
    sed -i -e "s/localhost/$MARIADB_HOST/g" /var/www/html/wp-config.php
else
    echo "WP CONFIG ALREADY EXIST"
fi

./wp-cli.phar core install --url=$DOMAIN_NAME --title=Inception --admin_user=root --admin_password=$MARIADB_ROOT_PASSWORD \
    --admin_email=jmougel@student.42lyon.fr --allow-root

exec "$@"
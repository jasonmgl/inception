#!/bin/bash

mkdir -p /run/php
chown www-data:www-data /run/php
chmod 755 /run/php
if [ -f "/var/www/html/wp-config.php" ]; then
    echo "wp-config.php already exist !"
else
    cd /var/www/html
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    ./wp-cli.phar core download --allow-root
    ./wp-cli.phar config create --dbname=wordpress --dbuser=user --dbpass=pass --dbhost=mariadb --allow-root
    ./wp-cli.phar core install --url=mariadb --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

exec "$@"
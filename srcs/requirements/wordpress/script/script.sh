#!/bin/bash

API_WP=$(curl https://api.wordpress.org/secret-key/1.1/salt/)

mkdir -p /run/php

chown -R www-data:www-data /var/www/html

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root

mv /wp-config.php /var/www/html/
sed -i -e "s/database_name_here/$DB_NAME/g" /var/www/html/wp-config.php
sed -i -e "s/username_here/$DB_ROOT_USER/g" /var/www/html/wp-config.php
sed -i -e "s/password_here/$DB_ROOT_PASS/g" /var/www/html/wp-config.php
sed -i -e "s/localhost/$DB_HOST/g" /var/www/html/wp-config.php
echo "$API_WP" >> /var/www/html/wp-config.php

./wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$DB_ROOT_USER --admin_password=$DB_ROOT_PASS \
    --admin_email=jmougel@student.42lyon.fr --allow-root

exec "$@"
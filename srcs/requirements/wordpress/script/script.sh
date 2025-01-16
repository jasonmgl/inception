#!/bin/bash

sleep 5

mkdir -p /run/php
chown -R www-data:www-data /run/php

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root 2> /dev/null

chown -R www-data:www-data /var/www/html

if [ ! -f "/var/www/html/wp-config.php" ]; then
    mv /wp-config.php /var/www/html/
    sed -i -e "s/database_name_here/$MARIADB_NAME/g" /var/www/html/wp-config.php
    sed -i -e "s/username_here/$MARIADB_USER/g" /var/www/html/wp-config.php
    sed -i -e "s/password_here/$MARIADB_USER_PASSWORD/g" /var/www/html/wp-config.php
    sed -i -e "s/localhost/$MARIADB_HOST/g" /var/www/html/wp-config.php
    sed -i -e "s|<REPLACE_HERE>|$API_WP|g" /var/www/html/wp-config.php
fi

if ! wp core is-installed --allow-root; then
    wp core install --url=$DOMAIN_NAME --title=Inception --admin_user=jmougel --admin_password=$MARIADB_ROOT_PASSWORD \
        --admin_email=jmougel@student.42lyon.fr --allow-root

    wp user create "${WORDPRESS_DB_USER}" "test@test.com" --user_pass="${WORDPRESS_DB_PASSWORD}" --role=author --allow-root
    wp theme install inspiro --activate --allow-root
else
    echo "Ready"
fi

exec "$@"
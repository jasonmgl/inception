#!/bin/bash

mkdir -p /run/php

chown www-data:www-data /run/php
chmod 755 /run/php

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

php wp-cli.phar --info

chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp --info
wp core download --path=wpclidemo.dev --allow-root

cp -r wpclidemo.dev/* /var/www/html
rm -rf wpclidemo.dev/

# wp config create --dbname=wpclidemo --dbuser=root --prompt=dbpass --allow-root
# wp db create --allow-root
# wp core install \
#     --url=wpclidemo.dev \
#     --title="WP-CLI" \
#     --admin_user=wpcli \
#     --admin_password=wpcli \
#     --admin_email=info@wp-cli.org --allow-root

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

exec "$@"
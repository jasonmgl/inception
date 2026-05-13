#!/bin/bash

WP_CLI=/usr/local/bin/wp
WP_CLI_URL=https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

install_wp_cli() {
    if [ -x "$WP_CLI" ]; then
        return 0
    fi

    curl -fsSL --connect-timeout 10 --max-time 60 -o "$WP_CLI" "$WP_CLI_URL"
    chmod +x "$WP_CLI"
}

wait_for_mariadb() {
    local tries=60

    until php -r '$host = getenv("MARIADB_HOST") ?: "mariadb"; $sock = @fsockopen($host, 3306, $errno, $errstr, 2); if (!$sock) exit(1); fclose($sock);'; do
        tries=$((tries - 1))
        if [ "$tries" -le 0 ]; then
            echo "MariaDB is not reachable" >&2
            return 1
        fi
        sleep 2
    done
}

generate_wordpress_salts() {
    local salt_file="$1"

    if curl -fsSL --connect-timeout 5 --max-time 20 https://api.wordpress.org/secret-key/1.1/salt/ > "$salt_file"; then
        return 0
    fi

    for key in AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT; do
        value=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 64)
        printf "define( '%s', '%s' );\n" "$key" "$value"
    done > "$salt_file"
}

replace_wordpress_salts() {
    local salt_file
    local config_tmp

    salt_file=$(mktemp)
    config_tmp=$(mktemp)

    generate_wordpress_salts "$salt_file"

    awk '
        NR == FNR {
            salts = salts $0 ORS
            next
        }
        $0 == "<REPLACE_HERE>" || $0 == "$(curl https://api.wordpress.org/secret-key/1.1/salt/)" {
            printf "%s", salts
            next
        }
        { print }
    ' "$salt_file" /var/www/html/wp-config.php > "$config_tmp"

    mv "$config_tmp" /var/www/html/wp-config.php
    rm -f "$salt_file"
}

mkdir -p /run/php
chown -R www-data:www-data /run/php

cd /var/www/html

install_wp_cli || exit 1

if [ ! -f "/var/www/html/wp-load.php" ]; then
    wp core download --allow-root || exit 1
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then
    mv /wp-config.php /var/www/html/
    sed -i -e "s/database_name_here/$MARIADB_NAME/g" /var/www/html/wp-config.php
    sed -i -e "s/username_here/$MARIADB_USER/g" /var/www/html/wp-config.php
    sed -i -e "s/password_here/$MARIADB_USER_PASSWORD/g" /var/www/html/wp-config.php
    sed -i -e "s/localhost/$MARIADB_HOST/g" /var/www/html/wp-config.php
    replace_wordpress_salts
elif grep -Fxq '<REPLACE_HERE>' /var/www/html/wp-config.php || grep -Fxq '$(curl https://api.wordpress.org/secret-key/1.1/salt/)' /var/www/html/wp-config.php; then
    replace_wordpress_salts
fi

chown -R www-data:www-data /var/www/html

wait_for_mariadb || exit 1

if ! wp core is-installed --allow-root; then
    wp core install --url=$DOMAIN_NAME --title=Inception --admin_user=jmougel --admin_password=$MARIADB_ROOT_PASSWORD \
        --admin_email=jmougel@student.42lyon.fr --allow-root || exit 1

    wp user get "${WORDPRESS_DB_USER:-$MARIADB_USER}" --allow-root > /dev/null 2>&1 || \
        wp user create "${WORDPRESS_DB_USER:-$MARIADB_USER}" "test@test.com" --user_pass="${WORDPRESS_DB_PASSWORD:-$MARIADB_USER_PASSWORD}" --role=author --allow-root
else
    echo "Ready"
fi

if ! wp plugin is-installed redis-cache --allow-root > /dev/null 2>&1; then
    timeout 120 wp plugin install redis-cache --activate --allow-root || true
else
    wp plugin activate redis-cache --allow-root || true
fi

if ! wp theme is-installed inspiro --allow-root > /dev/null 2>&1; then
    timeout 120 wp theme install inspiro --activate --allow-root || true
else
    wp theme activate inspiro --allow-root || true
fi

if wp plugin is-active redis-cache --allow-root > /dev/null 2>&1; then
    wp redis enable --allow-root || true
fi

exec "$@"

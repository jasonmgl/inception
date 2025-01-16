FROM debian:bullseye

EXPOSE 9000

RUN apt update -y && apt upgrade -y && apt install -y \
    curl=7.74.0-1.3+deb11u14 \
    php-fpm=2:7.4+76 \
    adminer=4.7.9-2  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/php && \
    mkdir -p /var/www/html && \
    cp -R /usr/share/adminer/ /var/www/html && \
    chown -R www-data:www-data /var/www/html

ENTRYPOINT ["/usr/sbin/php-fpm7.4", "-F"]
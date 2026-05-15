FROM debian:bullseye

EXPOSE 9000

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    php-fpm \
    adminer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/php && \
    mkdir -p /var/www/html && \
    cp -R /usr/share/adminer/ /var/www/html && \
    chown -R www-data:www-data /var/www/html

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

ENTRYPOINT ["/usr/sbin/php-fpm7.4", "-F"]

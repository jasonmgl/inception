FROM debian:bullseye

EXPOSE 9000

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    php-cli \
    php-fpm \
    php-redis \
    php-mysql && \
    curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY ./conf/wp-config.php /wp-config.php

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["/usr/sbin/php-fpm7.4", "-F"]

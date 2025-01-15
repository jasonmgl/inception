FROM debian:bullseye

EXPOSE 8000

RUN apt update -y && apt upgrade -y && apt install -y \
    curl=7.74.0-1.3+deb11u14 \
    php-fpm=2:7.4+76 \
    adminer=4.7.9-2  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/bin/adminer && \
    curl https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php /usr/bin/adminer/adminer.php && \
    chmod 777 /usr/bin/adminer/adminer.php

ENTRYPOINT ["/usr/sbin/php-fpm7.4", "-F"]
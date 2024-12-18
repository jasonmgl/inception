FROM debian:bullseye

EXPOSE 3306

RUN apt update -y && apt upgrade -y && apt install -y \
    wordpress=5.7.11+dfsg1-0+deb11u1 \
    php-fpm=2:7.4+76 && \
    rm -rf /var/lib/apt/lists/* # Clean up APT cache

CMD ["/usr/sbin/php-fpm7.3" "-F"]
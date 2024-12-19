FROM debian:bullseye

EXPOSE 9000

RUN apt update -y && apt upgrade -y && apt install -y \
    wordpress=5.7.11+dfsg1-0+deb11u1 \
    php-fpm=2:7.4+76 && \
    rm -rf /var/lib/apt/lists/* # Clean up APT cache

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]
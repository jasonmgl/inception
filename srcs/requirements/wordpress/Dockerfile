FROM debian:bullseye

EXPOSE 9000

RUN apt update -y && apt upgrade -y && apt install -y \
    dumb-init=1.2.5-1 \
    curl=7.74.0-1.3+deb11u14 \
    php=2:7.4+76 \
    php-zip=2:7.4+76 \
    php-fpm=2:7.4+76 \
    php-mysql=2:7.4+76 \
    php-cli=2:7.4+76 \
    php-curl=2:7.4+76 && \
    apt-get clean

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./script/script.sh /bin/script.sh

ENTRYPOINT ["dumb-init", "--"]

CMD ["/usr/bin/bash", "/bin/script.sh"]
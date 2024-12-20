FROM debian:bullseye

EXPOSE 9000

RUN apt update -y && apt upgrade -y && apt install -y \
    curl=7.74.0-1.3+deb11u14 \
    php=2:7.4+76 \
    php-zip=2:7.4+76 \
    php-fpm=2:7.4+76 \
    php-mysql=2:7.4+76 \
    php-cli=2:7.4+76 \
    php-curl=2:7.4+76 && \
    rm -rf /var/lib/apt/lists/* # Clean up APT cache

WORKDIR /var/www/html

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]
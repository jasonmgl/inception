FROM debian:bullseye

EXPOSE 9000

RUN apt update -y && apt upgrade -y && apt install -y \
    curl=7.74.0-1.3+deb11u14 \
    php-fpm=2:7.4+76 \
    php-mysql=2:7.4+76 && \
    apt-get clean

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY ./conf/wp-config.php /wp-config.php

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["/usr/sbin/php-fpm7.4", "-F"]
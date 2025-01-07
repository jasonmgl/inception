FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    dumb-init=1.2.5-1 \
    nginx=1.18.0-6.1+deb11u3 \
    openssl=1.1.1w-0+deb11u2 \
    gettext=0.21-4 && \
    apt-get clean

RUN chmod 755 /var/www/html

COPY ./conf/default.template /etc/nginx/sites-available/default.template

COPY ./script/script.sh /bin/script.sh

ENTRYPOINT ["dumb-init", "--"]

CMD ["bash", "/bin/script.sh"]
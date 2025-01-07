FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    nginx=1.18.0-6.1+deb11u3 \
    openssl=1.1.1w-0+deb11u2 && \
    apt-get clean

RUN chmod 755 /var/www/html

COPY ./conf/default /etc/nginx/sites-available/default

COPY ./script/script.sh /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["nginx", "-g", "daemon off;"]
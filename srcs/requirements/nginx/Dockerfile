FROM debian:bullseye

WORKDIR /home/jmougel/Documents/inception/srcs/nginx

RUN apt update -y && apt upgrade -y && apt install -y \
    nginx=1.18.0-6.1+deb11u3 \
    openssl=1.1.1w-0+deb11u2 \
    gettext=0.21-4 && \
    rm -rf /var/lib/apt/lists/* # Clean up APT cache

RUN chmod 755 /var/www/html

COPY ./conf/default.template /etc/nginx/sites-available/default.template
COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]
CMD ["nginx", "-g", "daemon off;"]
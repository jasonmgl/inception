FROM debian:bullseye

WORKDIR /home/jmougel/Documents/inception/srcs/nginx

RUN apt update -y && \
    apt upgrade -y && \
    apt install nginx openssl gettext -y && \
    rm -rf /var/lib/apt/lists/* # Clean up APT cache

RUN chmod 755 /var/www/html

COPY ./conf/default.template /etc/nginx/sites-available/default.template
COPY ./conf/index.template /var/www/html/index.template
COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["/bin/script.sh"]
CMD ["nginx", "-g", "daemon off;"]
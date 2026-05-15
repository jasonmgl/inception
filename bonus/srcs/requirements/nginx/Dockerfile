FROM debian:bullseye

EXPOSE 443

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/www/html2/

COPY ./conf/default /etc/nginx/sites-available/default

COPY ./index/index.html /var/www/html2/index.html

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["nginx", "-g", "daemon off;"]

FROM debian:bullseye

EXPOSE 443

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/default /etc/nginx/sites-available/default

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["nginx", "-g", "daemon off;"]

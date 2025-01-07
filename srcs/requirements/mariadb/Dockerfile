FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    dumb-init=1.2.5-1 \
    mariadb-server=1:10.5.26-0+deb11u2 && \
    apt-get clean

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf 

ENTRYPOINT ["dumb-init", "--"]

CMD ["bash", "/bin/script.sh"]
FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    mariadb-server=1:10.5.26-0+deb11u2 && \
    apt-get clean

COPY ./script/script.sh /bin/script.sh

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./init/init.sql /etc/mysql/init.sql

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["mysqld"]
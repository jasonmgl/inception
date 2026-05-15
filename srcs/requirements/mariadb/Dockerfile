FROM debian:bullseye

EXPOSE 3306

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/= 127.0.0.1/= 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    sed -i '/^port[[:space:]]*=/d; /basedir/i port\t\t\t\t\t= 3306' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["mysqld"]

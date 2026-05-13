FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["mysqld"]

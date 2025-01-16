FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    mariadb-server=1:10.5.26-0+deb11u2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["mysqld"]
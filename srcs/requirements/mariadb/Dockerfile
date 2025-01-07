FROM debian:bullseye

EXPOSE 3306

RUN apt update -y && apt upgrade -y && apt install -y \
    dumb-init=1.2.5-1 \
    mariadb-server=1:10.5.26-0+deb11u2 && \
    apt-get clean

COPY ./script/script.sh /bin/script.sh

ENTRYPOINT ["dumb-init", "--"]

CMD ["bash", "/bin/script.sh"]
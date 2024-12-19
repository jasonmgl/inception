FROM debian:bullseye

EXPOSE 3306

RUN apt update -y && apt upgrade -y && apt install -y \
    mariadb-server=1:10.5.26-0+deb11u2 && \
    rm -rf /var/lib/apt/lists/* # Clean up APT cache

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]
CMD ["mysql_secure"]
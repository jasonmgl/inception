FROM debian:bullseye

EXPOSE 6379

RUN apt update -y && apt upgrade -y && apt install -y \
    redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["redis-server", "--protected-mode no"]

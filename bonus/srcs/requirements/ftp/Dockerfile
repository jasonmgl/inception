FROM debian:bullseye

EXPOSE 20-21
EXPOSE 65500-65515

RUN apt update -y && apt upgrade -y && apt install -y \
    vsftpd=3.0.3-12+b1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["/usr/sbin/vsftpd"]
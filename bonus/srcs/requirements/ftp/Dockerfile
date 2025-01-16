FROM debian:bullseye

EXPOSE 20-21
EXPOSE 65500-65515

RUN apt update -y && apt upgrade -y && apt install -y \
    vsftpd=3.0.3-12+b1 \
    dumb-init=1.2.5-1  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/vsftpd/empty

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["dumb-init", "--", "bash", "/bin/script.sh"]

CMD ["dumb-init", "--", "vsftpd", "/etc/vsftpd.conf"]
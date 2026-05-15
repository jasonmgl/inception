FROM debian:bullseye

EXPOSE 20-21
EXPOSE 65500-65515

RUN apt-get update && apt-get install -y --no-install-recommends \
    vsftpd \
    dumb-init && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/vsftpd/empty

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["dumb-init", "--", "bash", "/bin/script.sh"]

CMD ["vsftpd", "/etc/vsftpd.conf"]

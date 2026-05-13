FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    iptables \
    fail2ban && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mv /etc/fail2ban/jail.conf /etc/fail2ban/jail.ori && \
    rm -f /etc/fail2ban/jail.d/defaults-debian.conf && \
    mkdir -p /var/log/vsftpd && \
    touch /var/log/vsftpd/vsftpd.log

COPY ./conf/jail.conf /etc/fail2ban/jail.conf
COPY ./conf/vsftpd.conf /etc/fail2ban/filter.d/vsftpd.conf

COPY ./script/script.sh /bin/script.sh

RUN chmod +x /bin/script.sh

ENTRYPOINT ["bash", "/bin/script.sh"]

CMD ["fail2ban-server", "-f"]

FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    fail2ban=0.11.2-2  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/fail2ban/jail.ori && \
    mv /etc/fail2ban/jail.conf /etc/fail2ban/jail.ori

COPY ./conf/jail.conf /etc/fail2ban/jail.conf
COPY ./conf/vsftpd.conf /etc/fail2ban/filter.d/vsftpd.conf

ENTRYPOINT ["fail2ban-server", "-f"]
#!/bin/bash

if [ ! -f "/etc/ssl/private/vsftpd.pem" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/vsftpd.pem \
        -out /etc/ssl/private/vsftpd.pem \
        -subj "/C=FR/L=Lyon/O=42/OU=student/CN=42"
fi

mv /etc/vsftpd.conf /etc/vsftpd.conf.ori

cat <<EOF  > /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
listen_address=0.0.0.0
listen_port=21

pasv_enable=YES
pasv_promiscuous=NO
pasv_min_port=65500
pasv_max_port=65515
pasv_address=0.0.0.0
port_promiscuous=NO

local_enable=YES
write_enable=YES
use_localtime=YES
local_umask=022

ftpd_banner=Welcome guys.

secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd

# rsa_cert_file=/etc/ssl/private/vsftpd.pem
# rsa_private_key_file=/etc/ssl/private/vsftpd.pem
ssl_enable=NO
ssl_ciphers=HIGH
ssl_tlsv1=NO
ssl_sslv2=NO
ssl_sslv3=NO
force_local_data_ssl=NO
force_local_logins_ssl=NO
allow_anon_ssl=NO

anonymous_enable=YES
anon_upload_enable=YES
anon_mkdir_write_enable=YES
EOF

exec "$@"
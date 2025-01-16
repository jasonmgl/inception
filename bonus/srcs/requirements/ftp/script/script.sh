#!/bin/bash

mv /etc/vsftpd.conf /etc/vsftpd.conf.ori

adduser --gecos "" $FTP_USER &> /dev/null
echo "$FTP_USER:$FTP_PASS" | chpasswd &> /dev/null
chown -R "$FTP_USER:$FTP_USER" /home/$FTP_USER/ftp &> /dev/null
chmod 777 /home/$FTP_USER/ftp &> /dev/null
chown "$FTP_USER:$FTP_USER" /home/john/ftp/upload &> /dev/null
echo "$FTP_USER" | tee -a /etc/vsftpd.userlist &> /dev/null

cat <<EOF  > /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
listen_address=0.0.0.0
listen_port=21
seccomp_sandbox=NO
connect_from_port_20=YES

log_ftp_protocol=YES
vsftpd_log_file=/var/log/vsftpd/vsftpd.log
xferlog_enable=YES
xferlog_file=/var/log/vsftpd/vsftpd.log
xferlog_std_format=NO

ftp_username=$FTP_USER
local_root=/home/$FTP_USER/ftp
secure_chroot_dir=/var/run/vsftpd/empty
allow_writeable_chroot=YES
chroot_local_user=YES

pasv_enable=YES
pasv_addr_resolve=YES
pasv_promiscuous=YES
pasv_min_port=65500
pasv_max_port=65515
pasv_address=0.0.0.0
port_promiscuous=YES

local_enable=YES
write_enable=YES
use_localtime=YES
local_umask=022

ftpd_banner=Welcome guys.
pam_service_name=vsftpd

ssl_enable=NO
ssl_ciphers=HIGH
ssl_tlsv1=NO
ssl_sslv2=NO
ssl_sslv3=NO
force_local_data_ssl=NO
force_local_logins_ssl=NO
allow_anon_ssl=NO

userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO

anonymous_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
EOF

exec "$@"
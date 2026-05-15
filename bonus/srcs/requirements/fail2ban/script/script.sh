#!/bin/bash

set -e

mkdir -p /var/log/vsftpd
touch /var/log/vsftpd/vsftpd.log

exec "$@"

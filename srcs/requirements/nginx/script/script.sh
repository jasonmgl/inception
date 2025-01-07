#!/bin/bash

mkdir -p /etc/nginx/ssl

if [ ! -f "/etc/nginx/ssl/"$CERTIF_NAME".crt" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/"$CERTIF_NAME".key \
        -out /etc/nginx/ssl/"$CERTIF_NAME".crt \
        -subj "/C=FR/L=Lyon/O=42/OU=student/CN=$DOMAIN_NAME"
fi

sed -i -e "s/DOMAIN_NAME/${DOMAIN_NAME}/g" /etc/nginx/sites-available/default

sed -i -e "s/CERTIF_NAME/${CERTIF_NAME}/g" /etc/nginx/sites-available/default

exec "$@"
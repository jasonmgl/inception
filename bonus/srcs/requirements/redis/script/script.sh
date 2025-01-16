#!/bin/bash

sed -i -e "s/bind 127.0.0.1 -::1/bind 0.0.0.0/g" /etc/redis/redis.conf

exec "$@"
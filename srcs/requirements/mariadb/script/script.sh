#!/bin/bash

mkdir -p /run/mysqls

chmod 755 /run/php

# mysql_secure_installation <<EOF
# y
# new_password
# new_password
# y
# y
# y
# y
# EOF

# exec "mysql"

exec mysql_secure_installation
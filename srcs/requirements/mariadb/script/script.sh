#!/bin/bash

mysql_secure_installation <<EOF
y
new_password
new_password
y
y
y
y
EOF

exec "$@"
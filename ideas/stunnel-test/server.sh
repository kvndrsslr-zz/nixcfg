#!/bin/sh

CWD=`pwd`

cat >cfg <<EOF
cert=$CWD/stunnel.pem
pid=$CWD/stunnel.pid
# setuid = stunnel
# setgid = stunnel
foreground = yes
output = /dev/stdout
[ssh]
accept = 443
connect = 127.0.0.1:2222
[syncthing]
accept = 443
connect = 127.0.0.1:22000
EOF

# cd /etc/ssl
# openssl genrsa 1024 > stunnel.key
# openssl req -new -key stunnel.key -x509 -days 1000 -out stunnel.crt
# cat stunnel.crt stunnel.key > stunnel.pem
# chmod 600 stunnel.pem

chmod 600 stunnel.pem

touch stunnel.pid

stunnel cfg


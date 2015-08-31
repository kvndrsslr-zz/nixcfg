#!/bin/sh

CWD=`pwd`

cat >cfg.client <<EOF
cert=$CWD/stunnel.pem
pid=$CWD/stunnel.pid
client=yes
# setuid = stunnel
# setgid = stunnel
foreground = yes
output = /dev/stdout
[ssh]
accept=443
connect=46.38.250.132:443
EOF

stunnel cfg.client

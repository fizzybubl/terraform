#!/bin/bash -xe

cat <<EOF >> /etc/systemd/resolved.conf 
DNS=${DNS_IP_1} ${DNS_IP_2}
Domains=~.
EOF
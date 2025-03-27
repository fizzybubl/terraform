#!/bin/bash -xe

dnf install -y NetworkManager
systemctl start NetworkManager
systemctl enable NetworkManager

nmcli con mod "eth0" ipv4.dns "${DNS_IP_1} ${DNS_IP_2}"
systemctl restart NetworkManager

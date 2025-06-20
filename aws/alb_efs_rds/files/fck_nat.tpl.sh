#!/bin/bash
echo "eni_id=${eni_id}" >> /etc/fck-nat.conf
service fck-nat restart
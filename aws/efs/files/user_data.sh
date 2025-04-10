#!/bin/bash -e

yum -y update
yum -y install nfs-utils

service nfs start
service nfs status
mkdir /efs
mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${MOUNT_ENDPOINT}:/ /efs

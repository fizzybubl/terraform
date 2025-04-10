#!/bin/bash -e

sudo yum -y update
sudo yum -y install nfs-utils

sudo service nfs start
sudo service nfs status

sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${MOUNT_ENDPOINT}:/ /efs
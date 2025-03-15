#!/bin/bash -xe
yum -y update
yum install -y httpd wget git
cd /tmp
git clone https://github.com/acantril/aws-sa-associate-saac02.git 
cp ./aws-sa-associate-saac02/11-Route53/r53_zones_and_failover/01_a4lwebsite/* /var/www/html
usermod -a -G apache ec2-user   
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
systemctl enable httpd
systemctl start httpd
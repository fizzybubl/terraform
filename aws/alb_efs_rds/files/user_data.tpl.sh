#!/bin/bash

DBPassword=$(aws ssm get-parameters --region '${region}' --names '${db_pw}' --with-decryption --query Parameters[0].Value)
DBPassword=`echo $DBPassword | sed -e 's/^"//' -e 's/"$//'`

DBRootPassword=$(aws ssm get-parameters --region '${region}' --names '${db_root_pw}' --with-decryption --query Parameters[0].Value)
DBRootPassword=`echo $DBRootPassword | sed -e 's/^"//' -e 's/"$//'`

DBUser=$(aws ssm get-parameters --region '${region}' --names '${db_user}' --query Parameters[0].Value)
DBUser=`echo $DBUser | sed -e 's/^"//' -e 's/"$//'`

DBName=$(aws ssm get-parameters --region '${region}' --names '${db_name}' --query Parameters[0].Value)
DBName=`echo $DBName | sed -e 's/^"//' -e 's/"$//'`

DBEndpoint=$(aws ssm get-parameters --region '${region}' --names '${db_endpoint}' --query Parameters[0].Value)
DBEndpoint=`echo $DBEndpoint | sed -e 's/^"//' -e 's/"$//'`

EFS_ID=$(aws ssm get-parameters --region us-east-1 --names '${efs_id}' --query Parameters[0].Value)
EFS_ID=`echo $EFS_ID | sed -e 's/^"//' -e 's/"$//'`


dnf -y update
dnf install wget php-mysqlnd httpd php-fpm php-mysqli php-json php php-devel mariadb105 stress amazon-efs-utils -y
# dnf install nfs-utils -y
systemctl enable httpd
systemctl start httpd

mkdir -p /var/www/html/wp-content
chown -R ec2-user:apache /var/www/
echo -e "$EFS_ID:/ /var/www/html/wp-content efs _netdev,tls,iam 0 0" >> /etc/fstab
mount -a -t efs defaults

wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
tar -zxvf latest.tar.gz
cp -rvf wordpress/* .
rm -R wordpress
rm latest.tar.gz

cp ./wp-config-sample.php ./wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
sed -i "s/'localhost'/'$DBEndpoint'/g" /var/www/html/wp-config.php

usermod -a -G apache ec2-user   
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

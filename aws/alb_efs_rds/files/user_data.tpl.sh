#!/bin/bash
dnf -y update
dnf install wget php-mysqlnd httpd php-fpm php-mysqli php-json php php-devel mariadb105 stress amazon-efs-utils -y
# dnf install nfs-utils -y
systemctl enable httpd
systemctl start httpd


# export DBPassword=$(aws ssm get-parameters --region eu-central-1 --names /dev/wordpress/db_pw --with-decryption --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')

# export DBUser=$(aws ssm get-parameters --region eu-central-1 --names /dev/wordpress/db_user --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')

# export DBName=$(aws ssm get-parameters --region eu-central-1 --names /dev/wordpress/db_name --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')

# export DBEndpoint=$(aws ssm get-parameters --region eu-central-1 --names /dev/wordpress/db_endpoint --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')

# export EFS_ID=$(aws ssm get-parameters --region eu-central-1 --names /dev/wordpress/efs_id --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')

export DBPassword=$(aws ssm get-parameters --region '${region}' --names '${db_pw}' --with-decryption --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')

export DBUser=$(aws ssm get-parameters --region '${region}' --names '${db_user}' --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')

export DBName=$(aws ssm get-parameters --region '${region}' --names '${db_name}' --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')

export DBEndpoint=$(aws ssm get-parameters --region '${region}' --names '${db_endpoint}' --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')

export EFS_ID=$(aws ssm get-parameters --region '${region}' --names '${efs_id}' --query Parameters[0].Value | sed -e 's/^"//' -e 's/"$//')


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

cat $(pwd)/wp-config-sample.php > $(pwd)/wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" $(pwd)/wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" $(pwd)/wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" $(pwd)/wp-config.php
sed -i "s/'localhost'/'$DBEndpoint'/g" $(pwd)/wp-config.php

usermod -a -G apache ec2-user   
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

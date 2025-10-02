#!/bin/sh
set -e


stack=$1

cd infra
terraform plan

if [ "$stack" = "new" ]; then
    terraform apply
    cd ../r53_new
    terraform plan
else
    terraform apply
    cd ../r53_old
    terraform plan
fi;
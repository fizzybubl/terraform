#!/bin/sh


STACK=$1

cd infra
teraform plan

if ["$STACK" = "new"]; then
    terraform apply
    cd ../r53_new
    terraform plan
else
    terraform apply
    cd ../r53_old
    terraform plan
fi;
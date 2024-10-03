aws eks update-kubeconfig --region eu-central-1 --name oidc-cluster

aws eks describe-cluster --name oidc-cluster --query cluster.resourcesVpcConfig.clusterSecurityGroupId

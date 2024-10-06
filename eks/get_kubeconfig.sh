aws eks update-kubeconfig --region eu-central-1 --name oidc-cluster

aws eks describe-cluster --name oidc-cluster --query cluster.resourcesVpcConfig.clusterSecurityGroupId


aws ssm get-parameter --name /aws/service/eks/optimized-ami/1.31/amazon-linux-2023/x86_64/standard/recommended/image_id  --region us-west-2 --query "Parameter.Value" --output text
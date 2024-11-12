aws eks update-kubeconfig --region eu-central-1 --name oidc-cluster

aws eks describe-cluster --name oidc-cluster --query cluster.resourcesVpcConfig.clusterSecurityGroupId


aws ssm get-parameter --name /aws/service/eks/optimized-ami/1.31/amazon-linux-2023/x86_64/standard/recommended/image_id  --region us-west-2 --query "Parameter.Value" --output text

aws eks describe-addon-versions --kubernetes-version 1.30  --query 'addons[].{MarketplaceProductUrl: marketplaceInformation.productUrl, Name: addonName, Owner: owner Publisher: publisher, Type: type}' --output table

aws eks describe-addon-versions --kubernetes-version 1.30 --addon-name aws-ebs-csi-driver --query 'addons[].addonVersions[].{Version: addonVersion, Defaultversion: compatibilities[0].defaultVersion}' --output table
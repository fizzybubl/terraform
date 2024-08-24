locals {
  labels = {
    "k8s-addon" = "cluster-autoscaler.addons.k8s.io",
    "k8s-app"   = "cluster-autoscaler"
  }
  name           = "cluster-autoscaler"
  rbac_api_group = "rbac.authorization.k8s.io"

  volume_name = "ssl-certs"
}

data "aws_region" "current" {}
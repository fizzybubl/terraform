locals {
  oidc_issuer      = replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
  addons_with_irsa = { for name, values in var.addons : name => values if values.policy_arn != null }
  addon_to_sa = {
    "aws-ebs-csi-driver"           = "ebs-csi-controller-sa"
    "aws-efs-csi-driver"           = "efs-csi-controller-sa"
    "aws-fsx-csi-driver"           = "fsx-csi-controller-sa"
    "aws-mountpoint-s3-csi-driver" = "s3-csi-driver-sa"
    "vpc-cni"                      = "aws-node"
  }
}
locals {
  oidc_issuer      = replace(var.control_plane.issuer, "https://", "")
  addons_with_irsa = { for name, values in var.addons : name => values if policy_arn != null }
  addon_to_sa = {
    "aws-ebs-csi-driver"           = "ebs-csi-controller-sa"
    "aws-efs-csi-driver"           = "efs-csi-controller-sa"
    "aws-fsx-csi-driver"           = "fsx-csi-controller-sa"
    "aws-mountpoint-s3-csi-driver" = "s3-csi-driver-sa"
    "vpc-cni"                      = "aws-node"
  }
}
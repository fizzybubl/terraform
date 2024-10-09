resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = aws_eks_cluster.control_plane.name
  addon_version            = "v1.18.5-eksbuild.1"
  addon_name               = "vpc-cni"
  service_account_role_arn = aws_iam_role.vpc_cni.arn
  configuration_values = jsonencode({
    enableNetworkPolicy = "true"
  })
}


resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.control_plane.name
  addon_version            = "v1.35.0-eksbuild.1"
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn

  depends_on = [ aws_eks_addon.vpc_cni ]
}
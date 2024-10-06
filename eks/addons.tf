resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.control_plane.name
  addon_version = "v1.18.5-eksbuild.1"
  addon_name    = "vpc-cni"
  configuration_values = jsonencode({
    enableNetworkPolicy = "true"
  })
}
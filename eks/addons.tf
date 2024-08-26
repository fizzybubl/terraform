resource "aws_eks_addon" "example" {
  cluster_name = aws_eks_cluster.control_plane.name
  addon_name   = "vpc-cni"

  configuration_values = jsonencode({
    enableNetworkPolicy = "true"
  })
}
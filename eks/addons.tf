# resource "aws_eks_addon" "example" {
#   cluster_name = aws_eks_cluster.control_plane.name
#   addon_name   = "vpc-cni"
#   service_account_role_arn = aws_iam_role.worker.arn
#   configuration_values = jsonencode({
#     enableNetworkPolicy = "true"
#   })
# }
module "cluster_autoscaler" {
  source = "./modules/cluster-autoscaler"
  openid_connect_provider = {
    arn = aws_iam_openid_connect_provider.control_plane.arn
  }
  control_plane = {
    issuer = aws_eks_cluster.control_plane.identity.0.oidc.0.issuer
    id  = aws_eks_cluster.control_plane.id
  }
}
output "control_plane" {
  value = aws_eks_cluster.this
}

output "oidc_issuer" {
  value = {
    arn = aws_iam_openid_connect_provider.cluster_oidc.arn
    url = local.oidc_issuer
  }
}
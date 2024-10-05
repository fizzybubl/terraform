resource "aws_eks_cluster" "control_plane" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = [for subnet in aws_subnet.private_subnet : subnet.id]
    security_group_ids      = [aws_security_group.eks.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

data "aws_partition" "current" {}


data "tls_certificate" "cluster_cert" {
  url = aws_eks_cluster.control_plane.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "control_plane" {
  url             = aws_eks_cluster.control_plane.identity[0].oidc[0].issuer
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [data.tls_certificate.cluster_cert.certificates[0].sha1_fingerprint]
}
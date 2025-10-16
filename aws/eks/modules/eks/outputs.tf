output "control_plane" {
  value = aws_eks_cluster.this
}

output "user_data" {
  value = templatefile("${path.module}/files/user_data.sh", {
    cluster_name          = var.cluster_name
    api_server_endpoint   = aws_eks_cluster.this.endpoint
    certificate_authority = aws_eks_cluster.this.certificate_authority[0].data
    service_cidr          = var.kubernetes_network_config.service_ipv4_cidr
  })
}
data "template_file" "user_data" {
  template = templatefile("${path.module}/files/userdata.tpl.sh", {
    cluster_name = aws_eks_cluster.control_plane.name,
    eks_endpoint = aws_eks_cluster.control_plane.endpoint,
    eks_ca       = aws_eks_cluster.control_plane.certificate_authority[0].data
  })
}

output "rendered" {
  value = data.template_file.user_data.rendered
}

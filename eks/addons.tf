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

  configuration_values = jsonencode({
    node = {
      kubeletPath = "/var/lib/kubelet"
    }
  })

  depends_on = [aws_eks_addon.vpc_cni, aws_eks_node_group.worker_nodes]
}


resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.control_plane.name
  addon_version = "v1.30.3-eksbuild.5"
  addon_name    = "kube-proxy"

  depends_on = [aws_eks_cluster.control_plane]
}


resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.control_plane.name
  addon_version = "v1.11.3-eksbuild.1"
  addon_name    = "coredns"

  depends_on = [aws_eks_cluster.control_plane]
}
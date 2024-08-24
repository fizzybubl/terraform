resource "aws_eks_node_group" "worker_nodes" {
    cluster_name = aws_eks_cluster.control_plane.name

    scaling_config {
      desired_size = 1
      max_size = 1
      min_size = 1
    }

    subnet_ids = aws_subnet.private_subnet[*].id
    node_role_arn = aws_iam_role.worker.arn

    launch_template {
      version = aws_launch_template.node.latest_version
      name = aws_launch_template.node.name
    }

    depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_launch_template" "node" {
  
}
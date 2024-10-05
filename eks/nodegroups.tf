resource "aws_eks_node_group" "worker_nodes" {
  cluster_name = aws_eks_cluster.control_plane.name

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  subnet_ids    = aws_subnet.public_subnet[*].id
  node_role_arn = aws_iam_role.worker.arn

  launch_template {
    version = aws_launch_template.node.latest_version
    name    = aws_launch_template.node.name
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}


data "aws_ssm_parameter" "eks_image" {
  name = "/aws/service/eks/optimized-ami/1.30/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

resource "aws_launch_template" "node" {
  name_prefix            = "eks_worker_template"
  image_id               = data.aws_ssm_parameter.eks_image.value
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.eks.id]

  depends_on = [aws_security_group.eks]


  tag_specifications {
    resource_type = "instance"
    tags = {
      "kubernetes.io/cluster/${aws_eks_cluster.control_plane.name}" = "owned"
    }
  }
}


resource "aws_autoscaling_group_tag" "enabled" {
  autoscaling_group_name = aws_eks_node_group.worker_nodes.resources[0].autoscaling_groups[0].name
  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = true
    propagate_at_launch = true
  }

  depends_on = [aws_eks_cluster.control_plane]
}


resource "aws_autoscaling_group_tag" "cluster_name" {
  autoscaling_group_name = aws_eks_node_group.worker_nodes.resources[0].autoscaling_groups[0].name
  tag {
    key                 = "k8s.io/cluster-autoscaler/${aws_eks_cluster.control_plane.name}"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  depends_on = [aws_eks_cluster.control_plane]
}
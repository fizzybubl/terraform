resource "aws_eks_node_group" "worker_nodes" {
  cluster_name    = aws_eks_cluster.control_plane.name
  node_group_name = "${aws_eks_cluster.control_plane.name}-group"
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 8
    max_size     = 10
    min_size     = 2
  }

  subnet_ids    = data.aws_subnets.private_subnets.ids
  node_role_arn = aws_iam_role.worker.arn

  launch_template {
    version = aws_launch_template.node.latest_version
    name    = aws_launch_template.node.name
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}


# resource "aws_eks_node_group" "spot_worker_nodes" {
#   cluster_name    = aws_eks_cluster.control_plane.name
#   node_group_name = "${aws_eks_cluster.control_plane.name}-spot-group"
#   capacity_type   = "SPOT"
#   instance_types  = ["t2.micro", "t3.micro"]

#   scaling_config {
#     desired_size = 2
#     max_size     = 10
#     min_size     = 2
#   }

#   subnet_ids    = aws_subnet.public_subnet[*].id
#   node_role_arn = aws_iam_role.worker.arn

#   launch_template {
#     version = aws_launch_template.node.latest_version
#     name    = aws_launch_template.node.name
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
#   ]
# }

data "aws_ssm_parameter" "eks_image" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.control_plane.version}/amazon-linux-2/recommended/image_id"
}


data "cloudinit_config" "user_data" {
  part {
    filename     = "userdata.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/userdata.tpl.sh", {
      cluster_name = aws_eks_cluster.control_plane.name
    })
  }
}


resource "aws_launch_template" "node" {
  name_prefix            = "eks_worker_template"
  image_id               = data.aws_ssm_parameter.eks_image.value
  vpc_security_group_ids = [aws_security_group.eks.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }

  user_data = data.cloudinit_config.user_data.rendered

  tag_specifications {
    resource_type = "instance"
    tags = {
      "kubernetes.io/cluster/${aws_eks_cluster.control_plane.name}"     = "owned",
      "eks:cluster-name"                                                = aws_eks_cluster.control_plane.name,
      "k8s.io/cluster-autoscaler/enabled"                               = true,
      "k8s.io/cluster-autoscaler/${aws_eks_cluster.control_plane.name}" = true
    }
  }

  depends_on = [aws_security_group.eks]
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
    value               = true
    propagate_at_launch = true
  }

  depends_on = [aws_eks_cluster.control_plane]
}
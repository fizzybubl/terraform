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
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.eks.id]

  depends_on = [aws_security_group.eks]

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
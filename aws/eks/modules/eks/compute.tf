# Worker policies
resource "aws_iam_role" "default_worker_role" {
  count = var.default_worker_role ? 1 : 0
  name  = "Default_EKS_WorkerNodeServiceRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.default_worker_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.default_worker_role.name
}


resource "aws_eks_node_group" "this" {
  for_each               = var.node_groups_config
  cluster_name           = aws_eks_cluster.this.name
  version                = var.version
  node_group_name        = each.value.name
  node_group_name_prefix = each.value.name_prefix
  node_role_arn          = coalesce(each.value.role_arn, aws_iam_role.default_worker_role[0])
  subnet_ids             = each.value.subnet_ids
  capacity_type          = each.value.capacity_type
  instance_types         = each.value.instance_types
  disk_size              = each.value.disk_size
  labels                 = each.value.labels

  launch_template {
    version = aws_launch_template.this.latest_version
    name    = aws_launch_template.this.name
  }


  node_repair_config {
    enabled = false
  }

  scaling_config {
    min_size     = each.value.min_size
    max_size     = each.value.max_size
    desired_size = each.value.desired_size
  }

  update_config {
    max_unavailable            = each.value.max_unavailable
    max_unavailable_percentage = each.value.max_unavailable_percentage
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}


resource "aws_launch_template" "this" {
  name                   = "${var.cluster_name}-template"
  image_id               = var.image_id
  vpc_security_group_ids = var.node_security_group_ids

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }

  user_data = var.user_data

  tag_specifications {
    resource_type = "instance"
    tags = {
      "kubernetes.io/cluster/${aws_eks_cluster.this.name}"     = "owned",
      "eks:cluster-name"                                       = aws_eks_cluster.this.name,
      "k8s.io/cluster-autoscaler/enabled"                      = true,
      "k8s.io/cluster-autoscaler/${aws_eks_cluster.this.name}" = true
    }
  }

  depends_on = [aws_eks_cluster.this]
}
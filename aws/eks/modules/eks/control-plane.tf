resource "aws_eks_cluster" "this" {
  name = var.cluster_name

  bootstrap_self_managed_addons = var.bootstrap_self_managed_addons
  enabled_cluster_log_types     = var.enabled_cluster_log_types
  role_arn                      = aws_iam_role.cluster.arn
  version                       = var.version


  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  dynamic "encryption_config" {
    for_each = var.key_arn != null ? [var.key_arn] : []

    content {
      resources = ["secrets"]
      provider {
        key_arn = var.key_arn
      }
    }
  }

  vpc_config {
    subnet_ids             = var.subnet_ids
    public_access_cidrs    = var.public_access_cidrs
    endpoint_public_access = var.endpoint_public_access
    security_group_ids     = var.security_group_ids
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.kubernetes_network_config.service_ipv4_cidr
    ip_family         = var.kubernetes_network_config.ip_family
  }

  upgrade_policy {
    support_type = var.support_type
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}
data "aws_ssm_parameter" "ami_id" {
  name = "/aws/service/eks/optimized-ami/1.32/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

module "eks" {
  source                  = "./modules/eks"
  cluster_name            = "test-loki"
  region                  = var.region
  image_id                = nonsensitive(data.aws_ssm_parameter.ami_id.value)
  security_group_ids      = [aws_security_group.fra.id]
  node_security_group_ids = [aws_security_group.fra.id]
  subnet_ids              = [for subnet in local.fra : aws_subnet.private_fra[subnet].id]
  addons = {
    "vpc-cni" = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      version    = "v1.20.3-eksbuild.1"
    }
    "coredns" = {
      version = "v1.11.4-eksbuild.24"
    }
    "kube-proxy" = {
      version = "v1.32.6-eksbuild.12"
    }
    "aws-ebs-csi-driver" = {
      version    = "v1.50.1-eksbuild.1"
      policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
    "snapshot-controller" = {
      version = "v8.3.0-eksbuild.1"
    }
    "metrics-server" = {
      version = "v0.8.0-eksbuild.2"
    }
  }
  access_entries = {
    admin = {
      principal_arn = data.aws_caller_identity.current.arn
    }
    test_1 = {
      principal_arn = aws_iam_role.readonly_1.arn
    }
    test_2 = {
      principal_arn = aws_iam_role.readonly_2.arn
    }
  }

  access_entries_policies = {
    admin = {
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      principal_arn = data.aws_caller_identity.current.arn
    }
    test_1 = {
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
      principal_arn = aws_iam_role.readonly_1.arn
      access_scope = {
        type       = "namespace"
        namespaces = ["application"]
      }
    }
    test_2 = {
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
      principal_arn = aws_iam_role.readonly_1.arn
      access_scope = {
        type       = "namespace"
        namespaces = ["monitoring"]
      }
    }
  }
  node_groups_config = {}
}
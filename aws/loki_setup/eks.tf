data "aws_ssm_parameter" "ami_id" {
  name = "/aws/service/eks/optimized-ami/1.32/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

module "eks" {
  source                  = "../eks/modules/eks"
  cluster_name            = "test-loki"
  region                  = var.region
  profile                 = var.profile
  image_id                = nonsensitive(data.aws_ssm_parameter.ami_id.value)
  security_group_ids      = [module.control_plane_sg.sg_id]
  node_security_group_ids = [module.nodes_sg.sg_id]
  subnet_ids              = [for key, subnet in aws_subnet.private_fra : subnet.id]
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
  access_entries = {}

  access_entries_policies = {}
  node_groups_config = {
    stateless = {
      node_group_name_prefix = "stateless-workload"
      subnet_ids             = [for key, subnet in aws_subnet.private_fra : subnet.id]
      capacity_type          = "SPOT"
      instance_types         = ["t3.micro", "t3.medium", "t3.small", "t3a.micro", "t3a.medium", "t3a.small"]
      labels = {
        type = "stateless"
      }
      min_size     = 1
      max_size     = 10
      desired_size = 3
    }
  }
}

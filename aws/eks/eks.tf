data "aws_ssm_parameter" "ami_id" {
  name = "/aws/service/eks/optimized-ami/1.32/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

module "eks" {
  source                  = "./modules/eks"
  cluster_name            = "test-loki"
  region                  = var.region
  image_id                = nonsensitive(data.aws_ssm_parameter.ami_id.value)
  user_data               = ""
  security_group_ids      = [aws_security_group.fra.id]
  node_security_group_ids = [aws_security_group.fra.id]
  subnet_ids              = [for subnet in local.fra: aws_subnet.private_fra[subnet].id]
  addons                  = {}
  node_groups_config      = {}
}
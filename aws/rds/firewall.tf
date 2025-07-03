module "name" {
  source      = "../ec2/modules/security_groups"
  vpc_id      = module.cloud_vpc.vpc_id
  name        = "rds"
  description = "rdss"

  ingress_rules = {
    "instance" = {
      from_port = "3306"
      to_port   = "3306"
      protocol  = "tcp"
      cidr_ipv4 = module.cloud_vpc.cidr_block
    }
  }

  egress_rules = {
    "all" = {
      from_port = 1
      to_port   = 65535
      protocol  = "tcp"
      cidr_ipv4 = module.cloud_vpc.cidr_block
    }
  }
}
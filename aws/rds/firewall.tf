module "rds_sg" {
  source      = "../ec2/modules/security_groups"
  vpc_id      = module.cloud_vpc.vpc_id
  name        = "rds"
  description = "rdss"

  ingress_rules = {
    "instance" = {
      description = "allow all connections to 3306"
      from_port   = "3306"
      to_port     = "3306"
      protocol    = "tcp"
      cidr_block  = module.cloud_vpc.cidr_block
    }
  }

  egress_rules = {
    "all" = {
      description = "allow all connections"
      from_port   = 1
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = module.cloud_vpc.cidr_block
    }
  }
}
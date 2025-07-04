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


module "rds" {
  source                 = "./modules/rds"
  username               = "admin"
  password               = "admin"
  subnet_ids             = [for az in local.az_ids : module.cloud_db[az].subnet_id]
  db_name                = "test"
  vpc_security_group_ids = [module.rds_sg.sg_id]
}
module "rds_sg" {
  source      = "../ec2/modules/security_groups"
  vpc_id      = module.cloud_vpc.vpc_id
  name        = "rds"
  description = "rdss"

  ingress_rules = {
    "instance" = {
      description    = "allow all connections to 3306"
      from_port      = "3306"
      to_port        = "3306"
      protocol       = "tcp"
      security_group = module.sg_ec2.sg_id
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
  source                 = "../rds/modules/rds"
  username               = var.db_user.value
  password               = var.db_pw.value
  subnet_ids             = [module.cloud_db_rtb.subnet_id, module.cloud_db[local.az2].subnet_id, module.cloud_db[local.az3].subnet_id]
  db_name                = var.db_name.value
  vpc_security_group_ids = [module.rds_sg.sg_id]
}
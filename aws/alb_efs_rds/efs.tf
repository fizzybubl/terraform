module "efs_sg" {
  source      = "../ec2/modules/security_groups"
  vpc_id      = module.cloud_vpc.vpc_id
  name        = "efs"
  description = "efs"

  ingress_rules = {
    "instance" = {
      description    = "allow all connections to 2049"
      from_port      = "2049"
      to_port        = "2049"
      protocol       = -1
      security_group = module.sg_ec2.sg_id
    }
  }

  egress_rules = {
    "all" = {
      description = "allow all connections"
      from_port   = 1
      to_port     = 65535
      protocol    = -1
      cidr_block  = module.cloud_vpc.cidr_block
    }
  }
}


module "efs" {
  source = "../efs/efs"
  name   = "EFS_Test"
  subnet_ids = {
    (local.az1) : {
      subnet_id       = module.cloud_app_rtb.subnet_id
      security_groups = [module.efs_sg.sg_id]
    },
    (local.az2) : {
      subnet_id       = module.cloud_app[local.az2].subnet_id
      security_groups = [module.efs_sg.sg_id]
    },
    (local.az3) : {
      subnet_id       = module.cloud_app[local.az3].subnet_id
      security_groups = [module.efs_sg.sg_id]
    }
  }
}
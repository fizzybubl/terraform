data "aws_ami" "ami" {
  filter {
    name   = "image-id"
    values = ["ami-0559679b06ebd7e58"]
  }
}


module "sg_ec2" {
  source = "../ec2/modules/security_groups"

  name        = "ec2-sg"
  vpc_id      = module.cloud_vpc.vpc_id
  description = "SG for EC2"

  ingress_rules = {
    "mysql" = {
      cidr_block  = module.cloud_vpc.cidr_block
      from_port   = 3306
      to_port     = 3306
      description = "MySQL Access"
      protocol    = "tcp"
    }
    "efs" = {
      cidr_block  = module.cloud_vpc.cidr_block
      from_port   = 2049
      to_port     = 2049
      description = "EFS Access"
      protocol    = "tcp"
    }
  }

  egress_rules = {
    "all_to_vpc" = {
      cidr_block  = module.cloud_vpc.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All to vpc"
      protocol    = -1
    }
  }
}


module "ec2" {
  source = "../ec2/modules/ec2"

  ami_id             = data.aws_ami.ami.id
  instance = true
  instance_type = "t2.micro"
  # subnet_ids         = concat([module.cloud_app_rtb.subnet_id], [for az_id in local.az_ids : module.cloud_app[az_id].subnet_id if az_id != local.az_ids[0]])
  subnet_ids         = [module.cloud_app_rtb.subnet_id]
  security_group_ids = [module.sg_ec2.sg_id]
  # instance_requirements = {
  #   allowed_instance_types = ["t2.micro", "t3.micro"]
  #   vcpu_count = {
  #     min = 1
  #   }
  #   memory_mib = {
  #     min = 500
  #   }
  # }
}
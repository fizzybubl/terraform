module "fck_nat_fra" {
  source             = "../../fck-nat"
  subnet_id          = aws_subnet.public_fra.id
  security_group_ids = [module.fck_nat_sg_fra.sg_id]
  private_ip_list    = ["10.0.150.100"]

  providers = {
    aws = aws.fra
  }
}



module "fck_nat_dub" {
  source             = "../../fck-nat"
  subnet_id          = aws_subnet.public_dub.id
  security_group_ids = [module.fck_nat_sg_dub.sg_id]
  private_ip_list    = ["10.100.150.100"]

  providers = {
    aws = aws.dub
  }
}


module "fck_nat_sg_fra" {
  source = "../../ec2/modules/security_groups"

  name        = "fck-nat-sg"
  vpc_id      = module.vpc_fra.vpc_id
  description = "SG for FCK NAT"

  ingress_rules = {
    "fck_nat_ingress" = {
      cidr_block  = module.vpc_fra.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All from VPC"
      protocol    = -1
    }
  }

  egress_rules = {
    "fck_nat_egress" = {
      cidr_block  = "0.0.0.0/0"
      from_port   = -1
      to_port     = -1
      description = "All egress"
      protocol    = -1
    }
  }

  providers = {
    aws = aws.fra
  }
}


module "fck_nat_sg_dub" {
  source = "../../ec2/modules/security_groups"

  name        = "fck-nat-sg"
  vpc_id      = module.vpc_dub.vpc_id
  description = "SG for FCK NAT"

  ingress_rules = {
    "fck_nat_ingress" = {
      cidr_block  = module.vpc_dub.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All from VPC"
      protocol    = -1
    }
  }

  egress_rules = {
    "fck_nat_egress" = {
      cidr_block  = "0.0.0.0/0"
      from_port   = -1
      to_port     = -1
      description = "All egress"
      protocol    = -1
    }
  }

  providers = {
    aws = aws.dub
  }
}
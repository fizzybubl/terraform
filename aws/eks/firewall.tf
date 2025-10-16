module "nodes_sg" {
  source = "../ec2/modules/security_groups"

  name        = "nodes-sg"
  vpc_id      = module.vpc_fra.vpc_id
  description = "SG for Node Groups"

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

  tags = {
    "Name" = "nodes-test-loki"
  }
}


module "control_plane_sg" {
  source = "../ec2/modules/security_groups"

  name        = "control-plane-sg"
  vpc_id      = module.vpc_fra.vpc_id
  description = "SG for Control Plane"

  ingress_rules = {
    "vpc" = {
      cidr_block  = module.vpc_fra.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All from VPC"
      protocol    = -1
    }
    "nodes" = {
      security_group = module.nodes_sg.sg_id
      from_port      = -1
      to_port        = -1
      description    = "All from VPC"
      protocol       = -1
    }
    "self" = {
      self        = true
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

  tags = {
    "Name" = "cluster-test-loki"
  }
}
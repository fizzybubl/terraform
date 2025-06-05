module "alb" {
  source = "../elb/alb"
  listeners = {
    http = {
    }
  }

  subnet_ids = [ for az in local.az_ids: module.cloud_web[az].subnet_id ]

  target_groups = {
    http = {
      asg_name     = module.ec2.asg_name
      name         = "ec2"
      vpc_id       = module.cloud_vpc.vpc_id
      port         = "80"
      health_check = {
        healthy_threshold = 2
        interval          = 10
        timeout           = 5
      }
      stickiness   = {}
      listener     = "http"
    }
  }

  security_group_ids = [ module.alb_sg.sg_id ]

  name = "stickiness-alb"
}


module "alb_sg" {
  source      = "../ec2/modules/security_groups" # adjust path
  name        = "alb-sg"
  description = "Example security group"
  vpc_id      = module.cloud_vpc.vpc_id
  
  tags = {
    Environment = "dev"
    Project     = "demo"
  }

  ingress_rules = {
    http = {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0" # only one destination here
    }
  }

  egress_rules = {
    all_outbound = {
      description = "Allow all outbound"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      cidr_block = module.cloud_vpc.cidr_block
    }
  }
}
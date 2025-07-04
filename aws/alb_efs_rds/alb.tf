module "alb_sg" {
  source      = "../ec2/modules/security_groups"
  vpc_id      = module.cloud_vpc.vpc_id
  name        = "alb"
  description = "alb"

  ingress_rules = {
    "instance" = {
      description = "allow all HTTP connections"
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    }
  }

  egress_rules = {
    "all" = {
      description    = "allow all connections to ec2"
      from_port      = "80"
      to_port        = "80"
      protocol       = "tcp"
      security_group = module.sg_ec2.sg_id
    }
  }
}

module "alb" {
  source = "../elb/alb"

  name = "alb-test"

  subnet_ids         = [module.cloud_web_rtb.subnet_id, module.cloud_web[local.az2].subnet_id, module.cloud_web[local.az3].subnet_id]
  security_group_ids = [module.alb_sg.sg_id]
  listeners = {
    "asg" = {
      port     = 80
      protocol = "HTTP"
    }
  }

  target_groups = {
    "asg" = {
      name     = "asg"
      asg_name = module.ec2.asg_name
      port     = 80
      protocol = "HTTP"
      vpc_id   = module.cloud_vpc.vpc_id
      health_check = {
        matcher = "200-399"
      }
      stickiness = {}
      listener   = "asg"
    }
  }
}

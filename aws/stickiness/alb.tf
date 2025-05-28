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
      health_check = {}
      stickiness   = {}
      listener     = "http"
    }
  }

  name = "stickiness-alb"
}
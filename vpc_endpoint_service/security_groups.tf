locals {
  security_groups = {
    vpc_ep = {
      security_group = {
        name   = "VPC_Interface_SecurityGroup"
        vpc_id = module.vpc["client"].vpc.id
        tags = {
          "Name" = "VPC_Interface_SecurityGroup"
        }
      }
      ingress = {
        vpc_inbound_access = {
          protocol  = -1
          from_port = -1
          to_port   = -1
          cidr_ipv4 = module.vpc["client"].vpc.cidr_block
        }
      }
      egress = {
        vpc_outbound_access = {
          protocol  = -1
          from_port = -1
          to_port   = -1
          cidr_ipv4 = module.vpc["client"].vpc.cidr_block
        }
      }
    }
    ec2_connect = {
      security_group = {
        name   = "EC2_Instance_Connect_SecurityGroup"
        vpc_id = module.vpc["client"].vpc.id
        tags = {
          "Name" = "EC2_Instance_Connect_SecurityGroup"
        }
      }
      ingress = {
        vpc_inbound_access = {
          protocol  = -1
          from_port = -1
          to_port   = -1
          cidr_ipv4 = module.vpc["client"].vpc.cidr_block
        }
        ec2_connect_inbound = {
          protocol       = -1
          from_port      = -1
          to_port        = -1
          prefix_list_id = data.aws_ec2_managed_prefix_list.ec2_instance_connect.id
        }
      }
      egress = {
        vpc_outbound_access = {
          protocol  = -1
          from_port = -1
          to_port   = -1
          cidr_ipv4 = module.vpc["client"].vpc.cidr_block
        }
      }
    }
    ssh = {
      security_group = {
        name   = "SSH_SecurityGroup"
        vpc_id = module.vpc["client"].vpc.id
        tags = {
          "Name" = "SSH_SecurityGroup"
        }
      }
      ingress = {
        inbound = {
          protocol  = "tcp"
          from_port = 22
          to_port   = 22
          cidr_ipv4 = local.public_internet
        }
      }
      egress = {
        outbound = {
          protocol  = -1
          from_port = -1
          to_port   = -1
          cidr_ipv4 = local.public_internet
        }
      }
    }
    alb = {
      security_group = {
        name   = "ALB_SecurityGroup"
        vpc_id = module.vpc["service"].vpc.id
        tags = {
          "Name" = "ALB_SecurityGroup"
        }
      }
      ingress = {
        vpc_inbound_access = {
          protocol  = -1
          from_port = -1
          to_port   = -1
          cidr_ipv4 = module.vpc["service"].vpc.cidr_block
        }
      }
      egress = {
        vpc_outbound_access = {
          protocol  = -1
          from_port = -1
          to_port   = -1
          cidr_ipv4 = module.vpc["service"].vpc.cidr_block
        }
      }
    }
  }
}

module "security_group" {
  for_each       = local.security_groups
  source         = "./modules/security_group"
  security_group = each.value.security_group
  ingress        = each.value.ingress
  egress         = each.value.egress
}


data "aws_ec2_managed_prefix_list" "ec2_instance_connect" {
  name = "com.amazonaws.${var.region}.ec2-instance-connect"
}
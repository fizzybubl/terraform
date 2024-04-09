terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~>4.16"
    }
  }
}

provider "aws" {
  region = var.region
}


locals {
  public_internet = "0.0.0.0/0"
  tags = {
    Group = "Terraform"
  }
}


data "aws_ami" "amazon_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-id"
    values = ["ami-0f7204385566b32d0"]
  }
}


module "create_aws_vpc_and_subnet" {
  source                = "./modules/create_aws_vpc_and_subnets"
  vpc_data              = var.vpc_data
  public_subnets_input  = var.public_subnets_input
  private_subnets_input = var.private_subnets_input
}


resource "aws_security_group" "alb_sg" {
  vpc_id      = module.create_aws_vpc_and_subnet.vpc.id
  name        = "ALB Security Group"
  description = "Allows all traffic from the same vpc"

  tags = local.tags
}


resource "aws_security_group" "ec2_sg" {
  vpc_id      = module.create_aws_vpc_and_subnet.vpc.id
  name        = "EC2 Security Group"
  description = "Allows all traffic from the same vpc"

  tags = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_traffic_from_alb" {
  security_group_id            = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  ip_protocol                  = "-1"
}


resource "aws_vpc_security_group_ingress_rule" "allow_public_traffic" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "allow_traffic_to_ec2" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
  ip_protocol                  = "-1"
}


# resource "aws_lb" "alb" {
#   name               = "ApplicationLoadBalancer"
#   internal           = false
#   load_balancer_type = "application"
#   subnets            = module.create_aws_vpc_and_subnet.public_subnets.*.id
# }


# resource "aws_placement_group" "test" {
#   name     = "test"
#   strategy = "spread"
# }


# resource "aws_launch_template" "launch_template" {
#   name_prefix          = "foobar"
#   image_id             = data.aws_ami.amazon_ami.id
#   instance_type        = var.instance_type
#   vpc_security_group_ids = [aws_security_group.ec2_sg.id]

#   depends_on = [aws_security_group.ec2_sg]
# }


# resource "aws_autoscaling_group" "ec2_asg" {
#   name                      = "auto_scaling_group"
#   max_size                  = 2
#   min_size                  = 1
#   desired_capacity          = 1
#   health_check_grace_period = 300
#   health_check_type         = "ELB"
#   placement_group           = aws_placement_group.test.id
#   vpc_zone_identifier       = module.create_aws_vpc_and_subnet.private_subnets.*.id

#   launch_template {
#     id      = aws_launch_template.launch_template.id
#     version = "$Latest"
#   }
# }


# resource "aws_lb_target_group" "lb_target_group" {
#   name     = "TerraformPractice"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = module.create_aws_vpc_and_subnet.vpc.id
# }

# resource "aws_autoscaling_attachment" "asg_attachment" {
#   autoscaling_group_name = aws_autoscaling_group.ec2_asg.id
#   lb_target_group_arn    = aws_lb_target_group.lb_target_group.arn
# }

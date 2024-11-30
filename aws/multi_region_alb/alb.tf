resource "aws_lb" "alb" {
  name               = "ApplicationLoadBalancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = toset([for s in module.vpc.public_subnets : s.id])
  security_groups    = toset([aws_security_group.alb.id])
}


resource "aws_security_group" "alb" {
  name   = "ALB_SecurityGroup"
  vpc_id = module.vpc.vpc.id

  tags = {
    "Name" = "ALB_SecurityGroup"
  }
}


resource "aws_vpc_security_group_ingress_rule" "vpc_inbound_access" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = module.vpc.vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "vpc_outbound_access" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = module.vpc.vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "internet_inbound_access" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_vpc_security_group_egress_rule" "internet_outbound_access" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}
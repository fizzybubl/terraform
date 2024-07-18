data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id      = data.aws_vpc.main.id
  name        = "ALB Security Group"
  description = "Allows all traffic from the same vpc"
}


resource "aws_security_group" "ec2_sg" {
  vpc_id      = data.aws_vpc.main.id
  name        = "EC2 Security Group"
  description = "Allows all traffic from the same vpc"
}

resource "aws_vpc_security_group_ingress_rule" "allow_traffic_from_alb" {
  security_group_id            = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_authorised_ips" {
  for_each          = var.authorised_ips
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "allow_traffic_to_ec2" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
  ip_protocol                  = "-1"
}


# resource "aws_vpc_security_group_egress_rule" "allow_traffic_to_alb" {
#   security_group_id            = aws_security_group.ec2_sg.id
#   referenced_security_group_id = aws_security_group.alb_sg.id
#   ip_protocol                  = "-1"
# }
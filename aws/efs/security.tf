data "aws_ec2_managed_prefix_list" "ec2_connect" {
  filter {
    name = "prefix-list-name"
    values = ["com.amazonaws.${var.region}.ec2-instance-connect"]
  }
}


resource "aws_security_group" "aws_ec2" {
  name   = "AWS_EC2"
  vpc_id = module.aws_vpc.vpc_id

  tags = {
    "Name" = "AllowALL_AWS"
  }
}

resource "aws_vpc_security_group_ingress_rule" "aws_vpc_access" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.aws_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "ec2_connect" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  prefix_list_id = data.aws_ec2_managed_prefix_list.ec2_connect.id
}


resource "aws_vpc_security_group_ingress_rule" "aws_ec2_instance_connect_access" {
  security_group_id            = aws_security_group.aws_ec2.id
  ip_protocol                  = -1
  from_port                    = -1
  to_port                      = -1
  referenced_security_group_id = aws_security_group.ssm_endpoint.id
}


resource "aws_vpc_security_group_egress_rule" "aws_vpc_outbound_access" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.aws_vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "internet_access" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}

# TODO: Add a separate SG for EFS
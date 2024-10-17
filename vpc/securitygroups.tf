# VPC Interface EP security group
resource "aws_security_group" "vpc_ep" {
  name   = "VPC_Interface_SecurityGroup"
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    "Name" = "VPC_Interface_SecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_inbound_access" {
  security_group_id = aws_security_group.vpc_ep.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = aws_vpc.custom_vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "vpc_outbound_access" {
  security_group_id = aws_security_group.vpc_ep.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = aws_vpc.custom_vpc.cidr_block
}


# VPC Interface EP security group
resource "aws_security_group" "internet" {
  name   = "EC2_Instance_Connect_SecurityGroup"
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    "Name" = "EC2_Instance_Connect_SecurityGroup"
  }
}


data "aws_ec2_managed_prefix_list" "ec2_instance_connect" {
  name = "com.amazonaws.${var.region}.ec2-instance-connect"
}


resource "aws_vpc_security_group_ingress_rule" "vpc_inbound_access_" {
  security_group_id = aws_security_group.internet.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = aws_vpc.custom_vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "vpc_outbound_access_" {
  security_group_id = aws_security_group.internet.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = aws_vpc.custom_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "ec_connect_inbound" {
  security_group_id = aws_security_group.internet.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  prefix_list_id = data.aws_ec2_managed_prefix_list.ec2_instance_connect.id
}

resource "aws_vpc_security_group_egress_rule" "ec_connect_outbound" {
  security_group_id = aws_security_group.internet.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  prefix_list_id = data.aws_ec2_managed_prefix_list.ec2_instance_connect.id
}
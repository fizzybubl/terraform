
# ON PREM

resource "aws_security_group" "on_prem_ec2" {
  name   = "GeneralSG"
  vpc_id = module.on_prem_vpc.vpc_id

  tags = {
    "Name" = "AllowAll"
  }
}

resource "aws_vpc_security_group_ingress_rule" "on_prem_vpc_inbound_access" {
  security_group_id = aws_security_group.on_prem_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         =  module.on_prem_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "ec2_instance_connect_inbound_access" {
  security_group_id = aws_security_group.on_prem_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  referenced_security_group_id = aws_security_group.ssm_endpoint.id
}


resource "aws_vpc_security_group_egress_rule" "on_prem_vpc_outbound_access" {
  security_group_id = aws_security_group.on_prem_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         =  module.on_prem_vpc.cidr_block
}



# AWS

resource "aws_security_group" "aws_ec2" {
  name   = "GeneralSG"
  vpc_id = module.aws_vpc.vpc_id

  tags = {
    "Name" = "AllowAll"
  }
}

resource "aws_vpc_security_group_ingress_rule" "aws_vpc_inbound_access" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         =  module.aws_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "aws_ec2_instance_connect_inbound_access" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  referenced_security_group_id = aws_security_group.ssm_endpoint.id
}


resource "aws_vpc_security_group_egress_rule" "aws_vpc_outbound_access" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         =  module.aws_vpc.cidr_block
}

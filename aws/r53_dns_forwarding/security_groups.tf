
# ON PREM

resource "aws_security_group" "on_prem_ec2" {
  name   = "ON_PREM"
  vpc_id = module.on_prem_vpc.vpc_id

  tags = {
    "Name" = "AllowALL_ON_PREM"
  }
}

resource "aws_vpc_security_group_ingress_rule" "on_prem_vpc_inbound_access" {
  security_group_id = aws_security_group.on_prem_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.on_prem_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "ec2_instance_connect_inbound_access" {
  security_group_id            = aws_security_group.on_prem_ec2.id
  ip_protocol                  = -1
  from_port                    = -1
  to_port                      = -1
  referenced_security_group_id = aws_security_group.ssm_endpoint["on_prem"].id
}


resource "aws_vpc_security_group_egress_rule" "on_prem_vpc_outbound_access" {
  security_group_id = aws_security_group.on_prem_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.on_prem_vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "on_prem_https_outbound_access" {
  security_group_id = aws_security_group.on_prem_ec2.id
  ip_protocol       = "TCP"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}



resource "aws_vpc_security_group_egress_rule" "on_prem_http_outbound_access" {
  security_group_id = aws_security_group.on_prem_ec2.id
  ip_protocol       = "TCP"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}


# AWS

resource "aws_security_group" "aws_ec2" {
  name   = "AWS_EC2"
  vpc_id = module.aws_vpc.vpc_id

  tags = {
    "Name" = "AllowALL_AWS"
  }
}

resource "aws_vpc_security_group_ingress_rule" "aws_vpc_inbound_access" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.aws_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "aws_ec2_instance_connect_inbound_access" {
  security_group_id            = aws_security_group.aws_ec2.id
  ip_protocol                  = -1
  from_port                    = -1
  to_port                      = -1
  referenced_security_group_id = aws_security_group.ssm_endpoint["aws"].id
}


resource "aws_vpc_security_group_egress_rule" "aws_vpc_outbound_access" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.aws_vpc.cidr_block
}


# VPC INBOUND
resource "aws_security_group" "vpc_inbound" {
  name   = "inbound-aws"
  vpc_id = module.aws_vpc.vpc_id

  tags = {
    "Name" = "Inbound-Resolver-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound_peer" {
  security_group_id = aws_security_group.vpc_inbound.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.on_prem_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "inbound_peer_tcp_53" {
  security_group_id = aws_security_group.vpc_inbound.id
  ip_protocol       = "TCP"
  from_port         = 53
  to_port           = 53
  cidr_ipv4         = module.on_prem_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "inbound_peer_udp_53" {
  security_group_id = aws_security_group.vpc_inbound.id
  ip_protocol       = "UDP"
  from_port         = 53
  to_port           = 53
  cidr_ipv4         = module.on_prem_vpc.cidr_block
}


# VPC OUTBOUND
resource "aws_security_group" "vpc_outbound" {
  name   = "outbound-aws"
  vpc_id = module.aws_vpc.vpc_id

  tags = {
    "Name" = "Outbound-Resolver-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "outbound_peer" {
  security_group_id = aws_security_group.vpc_outbound.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.on_prem_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "outbound_peer_tcp_53" {
  security_group_id = aws_security_group.vpc_outbound.id
  ip_protocol       = "TCP"
  from_port         = 53
  to_port           = 53
  cidr_ipv4         = module.on_prem_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "outbound_peer_udp_53" {
  security_group_id = aws_security_group.vpc_outbound.id
  ip_protocol       = "UDP"
  from_port         = 53
  to_port           = 53
  cidr_ipv4         = module.on_prem_vpc.cidr_block
}
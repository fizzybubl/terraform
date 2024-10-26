# VPC Interface EP security group
resource "aws_security_group" "vpc_ep" {
  name   = "VPC_Interface_SecurityGroup"
  vpc_id = module.vpc["client"].vpc.id

  tags = {
    "Name" = "VPC_Interface_SecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_inbound_access" {
  security_group_id = aws_security_group.vpc_ep.id
  ip_protocol       = "tcp"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.vpc["client"].vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "vpc_outbound_access" {
  security_group_id = aws_security_group.vpc_ep.id
  ip_protocol       = "tcp"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.vpc["client"].vpc.cidr_block
}

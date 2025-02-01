resource "aws_security_group" "shared" {
  vpc_id = aws_vpc.shared.id
  tags = {
    "Name" : "Shared Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_vpc" {
  security_group_id = aws_security_group.shared.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = aws_vpc.shared.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "allow_vpc" {
  security_group_id = aws_security_group.shared.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = aws_vpc.shared.cidr_block
}
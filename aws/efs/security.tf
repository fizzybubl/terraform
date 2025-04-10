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


resource "aws_vpc_security_group_egress_rule" "aws_vpc_outbound_access" {
  security_group_id = aws_security_group.aws_ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.aws_vpc.cidr_block
}

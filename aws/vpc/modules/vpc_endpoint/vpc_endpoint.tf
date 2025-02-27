
resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = var.type
  private_dns_enabled = var.private_dns_enabled
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids != null ? var.security_group_ids : [aws_security_group.this[0].id]
  tags                = var.tags
}


data "aws_vpc" "this" {
  id = var.vpc_id
}


# VPC Interface EP security group
resource "aws_security_group" "this" {
  count  = var.default_sg ? 1 : 0
  name   = "VPC_Interface_SecurityGroup"
  vpc_id = var.vpc_id

  tags = {
    "Name" = "VPC_Interface_SecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_inbound_access" {
  count             = var.default_sg ? 1 : 0
  security_group_id = aws_security_group.this[0].id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = data.aws_vpc.this.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "vpc_outbound_access" {
  count             = var.default_sg ? 1 : 0
  security_group_id = aws_security_group.this[0].id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = data.aws_vpc.this.cidr_block
}
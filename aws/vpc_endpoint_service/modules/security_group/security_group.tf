resource "aws_security_group" "this" {
  name   = var.security_group.name
  vpc_id = var.security_group.vpc_id
  tags   = var.security_group.tags
}


resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each                     = var.ingress
  security_group_id            = aws_security_group.this.id
  ip_protocol                  = each.value.protocol
  to_port                      = each.value.to_port
  from_port                    = each.value.to_port
  referenced_security_group_id = each.value.src_sg
  cidr_ipv4                    = each.value.cidr_ipv4
  prefix_list_id               = each.value.prefix_list_id

  tags = {
    "Name" = each.key
  }
}


resource "aws_vpc_security_group_egress_rule" "this" {
  for_each                     = var.egress
  security_group_id            = aws_security_group.this.id
  ip_protocol                  = each.value.protocol
  to_port                      = each.value.to_port
  from_port                    = each.value.to_port
  referenced_security_group_id = each.value.dest_sg
  cidr_ipv4                    = each.value.cidr_ipv4
  prefix_list_id               = each.value.prefix_list_id


  tags = {
    "Name" = each.key
  }
}
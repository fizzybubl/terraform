resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rules == null ? {} : var.ingress_rules

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol

  cidr_ipv4                    = each.value.cidr_block
  cidr_ipv6                    = each.value.ipv6_cidr_block
  referenced_security_group_id = each.value.self ? aws_security_group.this.id : each.value.security_group
  prefix_list_id               = each.value.prefix_list_id
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rules == null ? {} : var.egress_rules

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol

  cidr_ipv4                    = each.value.cidr_block
  cidr_ipv6                    = each.value.ipv6_cidr_block
  referenced_security_group_id = each.value.security_group
  prefix_list_id               = each.value.prefix_list_id
}

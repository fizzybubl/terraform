resource "aws_subnet" "this" {
  vpc_id = var.vpc_id

  cidr_block      = var.cidr_block
  ipv6_cidr_block = var.ipv6_cidr_block

  availability_zone       = var.az_name
  availability_zone_id    = var.az_id
  map_public_ip_on_launch = var.public_ip_on_launch

  tags = var.subnet_tags
}


resource "aws_route_table" "this" {
  count  = var.create_rtb ? 1 : 0
  vpc_id = var.vpc_id
}


resource "aws_route" "this" {
  for_each       = var.create_rtb ? var.routes : {}
  route_table_id = var.create_rtb ? aws_route_table.this[0].id : var.route_table_id

  destination_cidr_block      = lookup(each.value, "destination_cidr_block", null)
  destination_ipv6_cidr_block = lookup(each.value, "destination_ipv6_cidr_block", null)
  destination_prefix_list_id  = lookup(each.value, "destination_prefix_list_id", null)

  gateway_id                = coalesce(lookup(each.value, "internet_gateway_id", null), lookup(each.value, "virtual_private_gateway_id", null))
  nat_gateway_id            = lookup(each.value, "nat_gateway_id", null)
  transit_gateway_id        = lookup(each.value, "transit_gateway_id", null)
  vpc_peering_connection_id = lookup(each.value, "vpc_peering_connection_id", null)
  network_interface_id      = lookup(each.value, "network_interface_id", null)
  vpc_endpoint_id           = lookup(each.value, "vpc_endpoint_id", null)
  egress_only_gateway_id    = lookup(each.value, "egress_only_gateway_id", null)
}


resource "aws_route_table_association" "this" {
  route_table_id = var.create_rtb ? aws_route_table.this[0].id : var.route_table_id
  subnet_id      = aws_subnet.this.id
}


resource "aws_eip" "this" {
  count                = var.natgw ? 1 : 0
  domain               = "vpc"
  network_border_group = var.region
}


resource "aws_nat_gateway" "this" {
  count         = var.natgw ? 1 : 0
  subnet_id     = aws_subnet.this.id
  allocation_id = aws_eip.this[0].id
}


resource "aws_network_acl" "this" {
  count  = var.create_network_acl ? 1 : 0
  vpc_id = var.vpc_id
}


resource "aws_network_acl_rule" "ingress" {
  for_each       = var.create_network_acl ? var.ingress_acl : {}
  network_acl_id = var.create_network_acl ? aws_network_acl.this[0].id : var.network_acl_id

  rule_number     = each.value.rule_number
  egress          = false
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  cidr_block      = each.value.cidr_block
  from_port       = each.value.from_port
  to_port         = each.value.to_port
  ipv6_cidr_block = each.value.ipv6_cidr_block
}


resource "aws_network_acl_rule" "egress" {
  for_each       = var.create_network_acl ? var.egress_acl : {}
  network_acl_id = var.create_network_acl ? aws_network_acl.this[0].id : var.network_acl_id

  rule_number     = each.value.rule_number
  egress          = true
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  cidr_block      = each.value.cidr_block
  from_port       = each.value.from_port
  to_port         = each.value.to_port
  ipv6_cidr_block = each.value.ipv6_cidr_block
}
#### PRIVATE ####

resource "aws_route_table" "private" {
  for_each = var.private_route_tables
  vpc_id   = coalesce(lookup(each.value, "vpc_id", local.vpc_id), var.vpc_id, aws_vpc.this[0].id)
}


resource "aws_route" "private" {
  for_each       = var.private_routes
  route_table_id = aws_route_table.private[each.value.route_table].id

  destination_cidr_block      = lookup(each.value, "destination_cidr_block", null)
  destination_ipv6_cidr_block = lookup(each.value, "destination_ipv6_cidr_block", null)
  destination_prefix_list_id  = lookup(each.value, "destination_prefix_list_id", null)

  gateway_id                = lookup(each.value, "virtual_private_gateway_id", null)
  transit_gateway_id        = lookup(each.value, "transit_gateway_id", null)
  vpc_peering_connection_id = lookup(each.value, "vpc_peering_connection_id", null)
  network_interface_id      = lookup(each.value, "network_interface_id", null)
  vpc_endpoint_id           = lookup(each.value, "vpc_endpoint_id", null)
  # egress_only_gateway_id      = lookup(each.value, "egress_only_gateway_id", null)
}


# TODO: Add routes in private subnets towards natgateway

resource "aws_route_table_association" "private" {
  for_each       = var.private_routes_associations
  route_table_id = aws_route_table.private[split(":", each.value)[0]].id
  subnet_id      = aws_subnet.private[split(":", each.value)[1]].id
}


#### PUBLIC ####

resource "aws_route_table" "public" {
  for_each = var.public_route_tables
  vpc_id   = coalesce(lookup(each.value, "vpc_id", local.vpc_id), var.vpc_id, aws_vpc.this[0].id)
}

resource "aws_route" "public" {
  for_each       = var.public_routes
  route_table_id = aws_route_table.public[each.value.route_table].id

  destination_cidr_block      = lookup(each.value, "destination_cidr_block", null)
  destination_ipv6_cidr_block = lookup(each.value, "destination_ipv6_cidr_block", null)
  destination_prefix_list_id  = lookup(each.value, "destination_prefix_list_id", null)

  gateway_id                = coalesce(lookup(each.value, "internet_gateway_id", null), aws_internet_gateway.this[0].id)
  transit_gateway_id        = lookup(each.value, "transit_gateway_id", null)
  vpc_peering_connection_id = lookup(each.value, "vpc_peering_connection_id", null)
  network_interface_id      = lookup(each.value, "network_interface_id", null)
  vpc_endpoint_id           = lookup(each.value, "vpc_endpoint_id", null)
  egress_only_gateway_id    = lookup(each.value, "egress_only_gateway_id", null)
}


resource "aws_route_table_association" "public" {
  for_each       = var.public_routes_associations
  route_table_id = aws_route_table.public[split(":", each.value)[0]].id
  subnet_id      = aws_subnet.public[split(":", each.value)[1]].id
}
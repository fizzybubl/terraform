locals {
  natgw = var.natgw ? toset([for key, value in var.public_subnets : key]) : toset([])
}


resource "aws_eip" "this" {
  for_each             = local.natgw
  domain               = "vpc"
  network_border_group = var.region
}


resource "aws_nat_gateway" "this" {
  for_each      = local.natgw
  subnet_id     = aws_subnet.public[each.value].id
  allocation_id = aws_eip.this[each.value].id
}
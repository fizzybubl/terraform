resource "aws_vpc" "this" {
  count                = coalesce(var.vpc_id, false) ? 0 : 1
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.vpc_tags
}


locals {
  vpc_id = coalesce(var.vpc_id, aws_vpc.this[0].id)
}


resource "aws_internet_gateway" "this" {
  count  = var.igw ? 1 : 0
  vpc_id = local.vpc_id
}


resource "aws_subnet" "public" {
  for_each             = var.public_subnets
  vpc_id               = local.vpc_id
  availability_zone_id = lookup(each.value, "availability_zone_id", null)
  availability_zone    = lookup(each.value, "availability_zone", null)
  cidr_block           = each.value.cidr_block

  tags = lookup(each.value, "tags", null)

  depends_on = [aws_vpc.this]
}


resource "aws_subnet" "private" {
  for_each             = var.private_subnets
  vpc_id               = local.vpc_id
  availability_zone_id = lookup(each.value, "availability_zone_id", null)
  availability_zone    = lookup(each.value, "availability_zone", null)
  cidr_block           = each.value.cidr_block

  tags = lookup(each.value, "tags", null)

  depends_on = [aws_vpc.this]
}

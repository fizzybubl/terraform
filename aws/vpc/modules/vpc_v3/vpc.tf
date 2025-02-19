resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.vpc_tags
}

resource "aws_internet_gateway" "this" {
  count  = var.igw ? 1 : 0
  vpc_id = aws_vpc.this.id
}

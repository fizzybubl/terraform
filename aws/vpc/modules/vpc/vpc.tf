locals {
  public_internet = "0.0.0.0/0"
  tags = {
    Group = "Terraform"
  }
}


resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_data.cidr_block
  instance_tenancy     = var.vpc_data.instance_tenancy
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.tags, var.vpc_data.tags)
}


resource "aws_internet_gateway" "internet_gateway" {
  count = length(var.public_subnets_input) > 0 ? 1 : 0
  vpc_id = aws_vpc.custom_vpc.id
}


resource "aws_eip" "nat_gw_eip" {
  count = var.natgw ? 1 : 0
  domain               = "vpc"
  network_border_group = var.region
}


resource "aws_nat_gateway" "public_gw" {
  count = var.natgw ? 1 : 0
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.nat_gw_eip[0].id
}


resource "aws_route_table" "private_route_table" {
  count = length(var.private_subnets_input) > 0 ? 1 : 0
  vpc_id = aws_vpc.custom_vpc.id

  route {
    gateway_id = "local"
    cidr_block = aws_vpc.custom_vpc.cidr_block
  }

  dynamic "route" {
    for_each = range(var.natgw ? 1 : 0)
    content {
      nat_gateway_id = aws_nat_gateway.public_gw.id
      cidr_block     = "0.0.0.0/0"
    }
  }

  tags = {
    Type = "Private"
    Name = "Private Subnets route table"
  }
}


resource "aws_route_table" "public_route_table" {
  count = length(var.public_subnets_input) > 0 ? 1 : 0
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Type = "Public"
    Name = "Public Subnets route table"
  }

  route {
    gateway_id = aws_internet_gateway.internet_gateway[0].id
    cidr_block = local.public_internet
  }

  route {
    gateway_id = "local"
    cidr_block = aws_vpc.custom_vpc.cidr_block
  }
}


resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets_input)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.private_subnets_input[count.index].cidr_block
  availability_zone = var.private_subnets_input[count.index].availability_zone

  tags = var.private_subnets_input[count.index].tags

  depends_on = [aws_vpc.custom_vpc]
}


resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets_input)
  vpc_id                  = aws_vpc.custom_vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnets_input[count.index].cidr_block
  availability_zone       = var.public_subnets_input[count.index].availability_zone

  tags = var.public_subnets_input[count.index].tags

  depends_on = [aws_vpc.custom_vpc]
}


resource "aws_route_table_association" "route_to_subnet_association" {
  count          = length(var.private_subnets_input)
  route_table_id = aws_route_table.private_route_table[0].id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}


resource "aws_route_table_association" "route_to_public_subnet_association" {
  count          = length(var.public_subnets_input)
  route_table_id = aws_route_table.public_route_table[0].id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

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
  tags                 = local.tags
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.custom_vpc.id
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "Private Subnets route table"
  }

  route {
    gateway_id = "local"
    cidr_block = aws_vpc.custom_vpc.cidr_block
  }

  route {
    vpc_endpoint_id            = aws_vpc_endpoint.s3.id
    destination_prefix_list_id = data.aws_ec2_managed_prefix_list.s3.id
  }
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Type = "Public Subnet"
    Name = "Public Subnets route table"
  }

  route {
    gateway_id = aws_internet_gateway.internet_gateway.id
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

  tags = {
    Type = "Private Subnet"
    Name = "Private Subnet ${var.private_subnets_input[count.index].availability_zone}"
  }

  depends_on = [aws_vpc.custom_vpc]
}


resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets_input)
  vpc_id                  = aws_vpc.custom_vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnets_input[count.index].cidr_block
  availability_zone       = var.public_subnets_input[count.index].availability_zone

  tags = {
    Type = "Public Subnets"
    Name = "Public Subnet ${var.public_subnets_input[count.index].availability_zone}"
  }

  depends_on = [aws_vpc.custom_vpc]
}


resource "aws_route_table_association" "route_to_subnet_association" {
  count          = length(var.private_subnets_input)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}


resource "aws_route_table_association" "route_to_public_subnet_association" {
  count          = length(var.public_subnets_input)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

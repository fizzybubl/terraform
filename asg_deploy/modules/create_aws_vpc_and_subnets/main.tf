locals {
  public_internet = "0.0.0.0/0"
  tags = {
    Group = "Terraform"
  }
}


resource "aws_vpc" "custom_vpc" {
  cidr_block       = var.vpc_data.cidr_block
  instance_tenancy = var.vpc_data.instance_tenancy

  tags = local.tags
}


resource "aws_internet_gateway" "internet_gateway" {
}


resource "aws_internet_gateway_attachment" "internet_gateway_attachment" {
  vpc_id              = aws_vpc.custom_vpc.id
  internet_gateway_id = aws_internet_gateway.internet_gateway.id
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = local.tags
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = local.tags

  route = [
    {
      gateway_id = aws_internet_gateway.internet_gateway.id
      cidr_block = local.public_internet
    },
    {
      gateway_id = "local"
      cidr_block = aws_vpc.custom_vpc.cidr_block
    }
  ]
}


resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets_input)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.private_subnets_input[count.index].cidr_block
  availability_zone = var.private_subnets_input[count.index].availability_zone

  tags = local.tags

  depends_on = [aws_vpc.custom_vpc]
}


resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets_input)
  vpc_id                  = aws_vpc.custom_vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnets_input[count.index].cidr_block
  availability_zone       = var.public_subnets_input[count.index].availability_zone

  tags = local.tags

  depends_on = [aws_vpc.custom_vpc]
}


resource "aws_route_table_association" "route_to_subnet_association" {
  count          = length(var.private_subnets_input)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

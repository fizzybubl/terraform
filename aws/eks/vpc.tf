module "vpc_fra" {
  source               = "../vpc/modules/vpc_v3"
  vpc_cidr             = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  igw                  = true

  vpc_tags = {
    Name = "Fra"
  }
}


locals {
  fra = { "euc1-az1" : "10.0.100.0/24", "euc1-az2" : "10.0.200.0/24" }
}


resource "aws_subnet" "public_fra" {
  vpc_id                  = module.vpc_fra.vpc_id
  cidr_block              = "10.0.150.0/24"
  availability_zone_id    = "euc1-az1"
  map_public_ip_on_launch = true
}



resource "aws_subnet" "private_fra" {
  for_each             = local.fra
  vpc_id               = module.vpc_fra.vpc_id
  cidr_block           = each.value
  availability_zone_id = each.key
}

resource "aws_route_table" "public_fra" {
  vpc_id = module.vpc_fra.vpc_id

  route {
    cidr_block = module.vpc_fra.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc_fra.igw_id
  }

  tags = {
    Name = "Public Fra"
  }
}


resource "aws_route_table" "fra" {
  vpc_id = module.vpc_fra.vpc_id

  route {
    cidr_block = module.vpc_fra.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = module.fck_nat_fra.eni_id
  }

  tags = {
    Name = "Fra"
  }
}


resource "aws_route_table_association" "fra" {
  for_each       = local.fra
  subnet_id      = aws_subnet.private_fra[each.key].id
  route_table_id = aws_route_table.fra.id
}


resource "aws_route_table_association" "public_fra" {
  subnet_id      = aws_subnet.public_fra.id
  route_table_id = aws_route_table.public_fra.id
}

# AWS VPC

module "aws_vpc" {
  source               = "../vpc/modules/vpc_v3"
  igw                  = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  vpc_tags = {
    Name = "AWS VPC"
  }
}


module "aws_subnet_1" {
  source     = "../vpc/modules/subnet"
  vpc_id     = module.aws_vpc.vpc_id
  cidr_block = "10.0.1.0/24"
  az_id      = "euc1-az1"

  routes = {
    "peer" : {
      destination_cidr_block    = module.on_prem_vpc.cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
    }
  }

  subnet_tags = {
    "Name" : "AWS Subnet 1"
  }
}


module "aws_subnet_2" {
  source         = "../vpc/modules/subnet"
  vpc_id         = module.aws_vpc.vpc_id
  cidr_block     = "10.0.2.0/24"
  az_id          = "euc1-az2"
  create_rtb     = false
  route_table_id = module.aws_subnet_1.route_table_id

  subnet_tags = {
    "Name" : "AWS Subnet 1"
  }
}


# ON PREM VPC

module "on_prem_vpc" {
  source   = "../vpc/modules/vpc_v3"
  igw      = false
  vpc_cidr = "10.10.0.0/16"
  vpc_tags = {
    Name = "ON PREM VPC"
  }
}


module "on_prem_subnet_1" {
  source     = "../vpc/modules/subnet"
  vpc_id     = module.on_prem_vpc.vpc_id
  cidr_block = "10.10.1.0/24"
  az_id      = "euc1-az1"

  routes = {
    "peer" : {
      destination_cidr_block    = module.aws_vpc.cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
    }
  }

  subnet_tags = {
    "Name" : "AWS Subnet 1"
  }
}


module "on_prem_subnet_2" {
  source         = "../vpc/modules/subnet"
  vpc_id         = module.on_prem_vpc.vpc_id
  cidr_block     = "10.10.2.0/24"
  az_id          = "euc1-az2"
  create_rtb     = false
  route_table_id = module.on_prem_subnet_1.route_table_id

  subnet_tags = {
    "Name" : "ON PREM Subnet 2"
  }
}


## VPC PEERING

resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id = module.aws_vpc.vpc_id
  vpc_id      = module.on_prem_vpc.vpc_id

  tags = {
    Side = "Requester"
  }
}


resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}


resource "aws_vpc_peering_connection_options" "peer" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  accepter {
    allow_remote_vpc_dns_resolution = false
  }

  requester {
    allow_remote_vpc_dns_resolution = false
  }
}

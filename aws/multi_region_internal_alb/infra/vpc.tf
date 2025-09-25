module "vpc_fra" {
  source               = "../../vpc/modules/vpc_v3"
  vpc_cidr             = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  igw                  = true

  providers = {
    aws = aws.fra
  }

  vpc_tags = {
    Name = "Fra"
  }
}


module "vpc_dub" {
  source               = "../../vpc/modules/vpc_v3"
  vpc_cidr             = "10.100.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  igw                  = true

  providers = {
    aws = aws.dub
  }

  vpc_tags = {
    Name = "Dub"
  }
}



locals {
  fra = { "euc1-az1" : "10.0.100.0/24", "euc1-az2" : "10.0.200.0/24" }
  dub = { "euw1-az1" : "10.100.100.0/24", "euw1-az2" : "10.100.200.0/24" }
}


resource "aws_subnet" "public_fra" {
  vpc_id                  = module.vpc_fra.vpc_id
  cidr_block              = "10.0.150.0/24"
  availability_zone_id    = "euc1-az1"
  map_public_ip_on_launch = true

  provider = aws.fra
}


resource "aws_subnet" "public_dub" {
  vpc_id                  = module.vpc_dub.vpc_id
  cidr_block              = "10.100.150.0/24"
  availability_zone_id    = "euw1-az1"
  map_public_ip_on_launch = true

  provider = aws.dub
}


resource "aws_subnet" "private_fra" {
  for_each             = local.fra
  vpc_id               = module.vpc_fra.vpc_id
  cidr_block           = each.value
  availability_zone_id = each.key
}


resource "aws_subnet" "private_dub" {
  provider             = aws.dub
  for_each             = local.dub
  vpc_id               = module.vpc_dub.vpc_id
  cidr_block           = each.value
  availability_zone_id = each.key
}


resource "aws_route_table" "public_fra" {
  provider = aws.fra
  vpc_id   = module.vpc_fra.vpc_id

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



resource "aws_route_table" "public_dub" {
  provider = aws.dub
  vpc_id   = module.vpc_dub.vpc_id

  route {
    cidr_block = module.vpc_dub.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc_dub.igw_id
  }

  tags = {
    Name = "Public Dub"
  }
}


resource "aws_route_table" "fra" {
  provider = aws.fra
  vpc_id   = module.vpc_fra.vpc_id

  route {
    cidr_block = module.vpc_fra.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = module.fck_nat_fra.eni_id
  }

  route {
    cidr_block                = module.vpc_dub.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
  }

  tags = {
    Name = "Fra"
  }
}



resource "aws_route_table" "dub" {
  provider = aws.dub
  vpc_id   = module.vpc_dub.vpc_id

  route {
    cidr_block = module.vpc_dub.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block                = module.vpc_fra.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
  }

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = module.fck_nat_dub.eni_id
  }

  tags = {
    Name = "Dub"
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


resource "aws_route_table_association" "public_dub" {
  provider       = aws.dub
  subnet_id      = aws_subnet.public_dub.id
  route_table_id = aws_route_table.public_dub.id
}

resource "aws_route_table_association" "dub" {
  for_each       = local.dub
  provider       = aws.dub
  subnet_id      = aws_subnet.private_dub[each.key].id
  route_table_id = aws_route_table.dub.id

  depends_on = [aws_vpc_peering_connection.foo]
}


resource "aws_vpc_peering_connection" "foo" {
  provider      = aws.dub
  peer_owner_id = module.vpc_fra.owner_id
  peer_vpc_id   = module.vpc_fra.vpc_id # target vpc
  vpc_id        = module.vpc_dub.vpc_id # requester
  peer_region   = "eu-central-1"
  auto_accept   = false

  depends_on = [module.vpc_dub, module.vpc_fra]

  tags = {
    Name = "Requester"
  }
}


resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = aws.dub
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.name]
}




resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.fra
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.name]
}



resource "aws_vpc_peering_connection_accepter" "name" {
  provider                  = aws.fra
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
  auto_accept               = true
  tags = {
    Name = "Accepter"
  }
}


module "ssm_sg" {
  source = "../../ec2/modules/security_groups"

  name        = "ssm-sg"
  vpc_id      = module.vpc_fra.vpc_id
  description = "SG for SSM EP"

  ingress_rules = {
    "vpc_ingress" = {
      cidr_block  = module.vpc_fra.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All from VPC"
      protocol    = -1
    }
    "peer_ingress" = {
      cidr_block  = module.vpc_dub.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All from VPC"
      protocol    = -1
    }
  }

  egress_rules = {
    "vpc_egress" = {
      cidr_block  = "0.0.0.0/0"
      from_port   = -1
      to_port     = -1
      description = "All to vpc"
      protocol    = -1
    }
  }
}


module "ssm_sg_dub" {
  providers = {
    aws = aws.dub
  }
  source = "../../ec2/modules/security_groups"

  name        = "ssm-sg"
  vpc_id      = module.vpc_dub.vpc_id
  description = "SG for SSM EP"

  ingress_rules = {
    "vpc_ingress" = {
      cidr_block  = module.vpc_dub.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All from VPC"
      protocol    = -1
    }
    "peer_ingress" = {
      cidr_block  = module.vpc_fra.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All from VPC"
      protocol    = -1
    }
  }

  egress_rules = {
    "vpc_egress" = {
      cidr_block  = "0.0.0.0/0"
      from_port   = -1
      to_port     = -1
      description = "All to vpc"
      protocol    = -1
    }
  }
}


# module "ssm" {
#   for_each            = toset(["ssm", "ssmmessages", "ec2messages"])
#   source              = "../vpc/modules/vpc_endpoint"
#   private_dns_enabled = true
#   default_sg          = false
#   security_group_ids  = [module.ssm_sg.sg_id]
#   service_name        = "com.amazonaws.eu-central-1.${each.value}"
#   vpc_id              = aws_vpc.fra.id
#   subnet_ids          = [for key, subnet in aws_subnet.private_fra : subnet.id]
# }

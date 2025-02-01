# When using RAM for subnets, each account has INDEPENDENT TAGGING, meaning that the name created by the owner of the resources will not be visile for the other participants
# However, participants have the flexibility to create their own names

locals {
  az_ids = ["euc1-az1", "euc1-az2", "euc1-az3"]

  db_subnets = {
    "euc1-az1" = {
      availability_zone_id = "euc1-az1"
      cidr_block           = "10.0.1.0/24"
      tags = {
        "Name" : "Private Subnet DB AZ1"
      }
    },
    "euc1-az2" = {
      availability_zone_id = "euc1-az2"
      cidr_block           = "10.0.2.0/24"
      tags = {
        "Name" : "Private Subnet DB AZ2"
      }
    },
    "euc1-az3" = {
      availability_zone_id = "euc1-az3"
      cidr_block           = "10.0.3.0/24"
      tags = {
        "Name" : "Private Subnet DB AZ3"
      }
    }
  }

  app_subnets = {
    "euc1-az1" = {
      availability_zone_id = "euc1-az1"
      cidr_block           = "10.0.10.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ1"
      }
    },
    "euc1-az2" = {
      availability_zone_id = "euc1-az2"
      cidr_block           = "10.0.11.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ2"
      }
    },
    "euc1-az3" = {
      availability_zone_id = "euc1-az3"
      cidr_block           = "10.0.12.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ3"
      }
    }

  }

  web_subnets = {
    "euc1-az1" = {
      availability_zone_id = "euc1-az1"
      cidr_block           = "10.0.100.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ1"
      }
    },
    "euc1-az2" = {
      availability_zone_id = "euc1-az2"
      cidr_block           = "10.0.101.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ2"
      }
    },
    "euc1-az3" = {
      availability_zone_id = "euc1-az3"
      cidr_block           = "10.0.102.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ3"
      }
    }

  }
}


resource "aws_vpc" "shared" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" : "Shared"
  }
}


resource "aws_subnet" "db" {
  for_each             = local.db_subnets
  vpc_id               = aws_vpc.shared.id
  availability_zone_id = each.value.availability_zone_id
  cidr_block           = each.value.cidr_block
  tags                 = each.value.tags
}



resource "aws_subnet" "app" {
  for_each             = local.app_subnets
  vpc_id               = aws_vpc.shared.id
  availability_zone_id = each.value.availability_zone_id
  cidr_block           = each.value.cidr_block
  tags                 = each.value.tags
}


resource "aws_subnet" "web" {
  for_each             = local.web_subnets
  vpc_id               = aws_vpc.shared.id
  availability_zone_id = each.value.availability_zone_id
  cidr_block           = each.value.cidr_block
  tags                 = each.value.tags
}


# resource "aws_eip" "nat_gw_eip" {
#   for_each = local.az_ids
#   domain               = "vpc"
#   network_border_group = var.region
# }


# resource "aws_nat_gateway" "public_gw" {
#   for_each      = local.web_subnets
#   subnet_id     = aws_subnet.web[each.key].id
#   allocation_id = aws_eip.nat_gw_eip[each.key].id
# }



resource "aws_route_table" "shared_private" {
  for_each = toset(local.az_ids)
  vpc_id   = aws_vpc.shared.id

  route {
    gateway_id = "local"
    cidr_block = aws_vpc.shared.cidr_block
  }

  # route {
  #   nat_gateway_id = aws_nat_gateway.public_gw[each.value].id
  #   cidr_block     = "0.0.0.0/0"
  # }

  tags = {
    Type = "Private"
    Name = "Private Shared Route Table AZ ${each.value}"
  }
}


resource "aws_route_table" "shared_public" {
  vpc_id = aws_vpc.shared.id

  route {
    gateway_id = "local"
    cidr_block = aws_vpc.shared.cidr_block
  }

  route {
    gateway_id = aws_internet_gateway.shared.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Type = "Public"
    Name = "Public Shared Route Table"
  }
}


resource "aws_route_table_association" "db" {
  for_each       = local.db_subnets
  route_table_id = aws_route_table.shared_private[each.key].id
  subnet_id      = aws_subnet.db[each.key].id
}


resource "aws_route_table_association" "app" {
  for_each       = local.app_subnets
  route_table_id = aws_route_table.shared_private[each.key].id
  subnet_id      = aws_subnet.app[each.key].id
}


resource "aws_route_table_association" "web" {
  for_each       = local.web_subnets
  route_table_id = aws_route_table.shared_public.id
  subnet_id      = aws_subnet.web[each.key].id
}


resource "aws_internet_gateway" "shared" {
  vpc_id = aws_vpc.shared.id

  tags = {
    Name = "Shared"
  }
}
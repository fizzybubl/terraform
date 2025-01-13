locals {
  private_subnets_tgw_prod = [
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.0.1.0/28"
      tags = {
        "Name" : "Private Subnet PROD TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.0.2.0/28"
      tags = {
        "Name" : "Private Subnet PROD TGW 1c"
      }
    }
  ]

  private_subnets_tgw_pre_prod = [
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.1.1.0/28"
      tags = {
        "Name" : "Private Subnet PREPROD TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.1.2.0/28"
      tags = {
        "Name" : "Private Subnet PREPROD TGW 1c"
      }
    }
  ]

  private_subnets_tgw_stg = [
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.2.1.0/28"
      tags = {
        "Name" : "Private Subnet STG TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.2.2.0/28"
      tags = {
        "Name" : "Private Subnet STG TGW 1c"
      }
    }
  ]

  private_subnets_tgw_dev = [
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.3.1.0/28"
      tags = {
        "Name" : "Private Subnet DEV TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.3.2.0/28"
      tags = {
        "Name" : "Private Subnet DEV TGW 1c"
      }
    }
  ]

  private_subnets_tgw_dmz = [
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.100.201.0/28"
      tags = {
        "Name" : "Public Subnet DMZ TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.100.202.0/28"
      tags = {
        "Name" : "Public Subnet DMZ TGW 1c"
      }
    }
  ]
}

## ==== PROD =======
resource "aws_vpc" "prod" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" : "PROD"
  }
}


resource "aws_subnet" "private_instance_prod" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.0.0.0/24"
  tags = {
    "Name" : "Private Instance Subnet PROD"
  }
}


resource "aws_subnet" "private_tgw_prod" {
  count             = length(local.private_subnets_tgw_prod)
  vpc_id            = aws_vpc.prod.id
  availability_zone = local.private_subnets_tgw_prod[count.index].availability_zone
  cidr_block        = local.private_subnets_tgw_prod[count.index].cidr_block
  tags              = local.private_subnets_tgw_prod[count.index].tags
}


## ==== PRE PROD =======
resource "aws_vpc" "pre_prod" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" : "PREPROD"
  }
}


resource "aws_subnet" "private_instance_pre_prod" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.1.0.0/24"
  tags = {
    "Name" : "Private Subnet Instance PREPROD"
  }
}


resource "aws_subnet" "private_tgw_pre_prod" {
  count             = length(local.private_subnets_tgw_pre_prod)
  vpc_id            = aws_vpc.prod.id
  availability_zone = local.private_subnets_tgw_pre_prod[count.index].availability_zone
  cidr_block        = local.private_subnets_tgw_pre_prod[count.index].cidr_block
  tags              = local.private_subnets_tgw_pre_prod[count.index].tags
}


resource "aws_route_table" "prod_private" {
  vpc_id = aws_vpc.prod.id

  route {
    gateway_id = "local"
    cidr_block = aws_vpc.prod.cidr_block
  }

  route {
    transit_gateway_id = aws_ec2_transit_gateway.example.id
    cidr_block         = "10.0.0.0/8"
  }

  tags = {
    Type = "Private"
    Name = "PROD Instance Route Table"
  }
}


resource "aws_route_table_association" "prod" {
  route_table_id = aws_route_table.prod_private.id
  subnet_id      = aws_subnet.private_instance_prod.id
}


resource "aws_route_table_association" "pre_prod" {
  route_table_id = aws_route_table.prod_private.id
  subnet_id      = aws_subnet.private_instance_prod.id
}


## ==== STG =======
resource "aws_vpc" "stg" {
  cidr_block       = "10.2.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" : "STG"
  }
}


resource "aws_subnet" "private_instance_stg" {
  vpc_id            = aws_vpc.stg.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.2.0.0/24"
  tags = {
    "Name" : "Private Subnet Instance STG"
  }
}


resource "aws_subnet" "private_tgw_stg" {
  count             = length(local.private_subnets_tgw_stg)
  vpc_id            = aws_vpc.prod.id
  availability_zone = local.private_subnets_tgw_stg[count.index].availability_zone
  cidr_block        = local.private_subnets_tgw_stg[count.index].cidr_block
  tags              = local.private_subnets_tgw_stg[count.index].tags
}


## ==== DEV =======
resource "aws_vpc" "dev" {
  cidr_block       = "10.3.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" : "DEV"
  }
}


resource "aws_subnet" "private_instance_dev" {
  vpc_id            = aws_vpc.dev.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.3.0.0/24"
  tags = {
    "Name" : "Private Subnet Instance DEV"
  }
}


resource "aws_subnet" "private_tgw_dev" {
  count             = length(local.private_subnets_tgw_dev)
  vpc_id            = aws_vpc.prod.id
  availability_zone = local.private_subnets_tgw_dev[count.index].availability_zone
  cidr_block        = local.private_subnets_tgw_dev[count.index].cidr_block
  tags              = local.private_subnets_tgw_dev[count.index].tags
}


resource "aws_route_table" "dev_private" {
  vpc_id = aws_vpc.dev.id

  route {
    gateway_id = "local"
    cidr_block = aws_vpc.dev.cidr_block
  }

  route {
    transit_gateway_id = aws_ec2_transit_gateway.example.id
    cidr_block         = "10.0.0.0/8"
  }

  tags = {
    Type = "Private"
    Name = "Dev Instance Route Table"
  }
}


resource "aws_route_table_association" "stg" {
  route_table_id = aws_route_table.dev_private.id
  subnet_id      = aws_subnet.private_instance_stg.id
}


resource "aws_route_table_association" "dev" {
  route_table_id = aws_route_table.dev_private.id
  subnet_id      = aws_subnet.private_instance_dev.id
}


## ==== DMZ =======
resource "aws_vpc" "dmz" {
  cidr_block       = "10.100.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" : "DMZ"
  }
}


resource "aws_subnet" "public_outbound" {
  vpc_id            = aws_vpc.dev.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.100.0.0/24"
  tags = {
    "Name" : "Public Outbound"
  }
}


resource "aws_subnet" "private_tgw_dmz" {
  count             = length(local.private_subnets_tgw_dmz)
  vpc_id            = aws_vpc.prod.id
  availability_zone = local.private_subnets_tgw_dmz[count.index].availability_zone
  cidr_block        = local.private_subnets_tgw_dmz[count.index].cidr_block
  tags              = local.private_subnets_tgw_dmz[count.index].tags
}


resource "aws_route_table" "dmz_private" {
  vpc_id = aws_vpc.dmz.id

  route {
    gateway_id = "local"
    cidr_block = aws_vpc.dmz.cidr_block
  }

  route {
    nat_gateway_id = aws_nat_gateway.public_gw.id
    cidr_block         = "0.0.0.0/0"
  }

  tags = {
    Type = "Private"
    Name = "DMZ Instance Route Table"
  }
}


resource "aws_route_table" "dmz_public" {
  vpc_id = aws_vpc.dmz.id

  route {
    gateway_id = "local"
    cidr_block = aws_vpc.dmz.cidr_block
  }

  route {
    transit_gateway_id = aws_ec2_transit_gateway.example.id
    cidr_block         = "10.0.0.0/8"
  }

  tags = {
    Type = "Private"
    Name = "DMZ Public Route Table"
  }
}


resource "aws_route_table_association" "dmz_private" {
  route_table_id = aws_route_table.dmz_private.id
  subnet_id      = aws_subnet.private_tgw_dmz.id
}


resource "aws_route_table_association" "dmz_public" {
  route_table_id = aws_route_table.dmz_public.id
  subnet_id      = aws_subnet.public_outbound.id
}


resource "aws_eip" "nat_gw_eip" {
  domain               = "vpc"
  network_border_group = var.region
}


resource "aws_nat_gateway" "public_gw" {
  count         = var.natgw ? 1 : 0
  subnet_id     = aws_subnet.dmz_public.id
  allocation_id = aws_eip.nat_gw_eip.id
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dmz.id

  tags = {
    Name = "DMZ"
  }
}
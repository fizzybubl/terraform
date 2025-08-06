locals {
  az1 = "euc1-az1"
  az2 = "euc1-az2"
  az3 = "euc1-az3"

  az_ids = [local.az1, local.az2, local.az3]


  cloud_app_subnets = {
    (local.az1) = {
      availability_zone_id = local.az1
      cidr_block           = "10.0.10.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ1"
      }
    },
    (local.az2) = {
      availability_zone_id = local.az2
      cidr_block           = "10.0.11.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ2"
      }
    },
    (local.az3) = {
      availability_zone_id = local.az3
      cidr_block           = "10.0.12.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ3"
      }
    }
  }

  cloud_web_subnets = {
    (local.az1) = {
      availability_zone_id = local.az1
      cidr_block           = "10.0.100.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ1"
      }
    },
    (local.az2) = {
      availability_zone_id = local.az2
      cidr_block           = "10.0.101.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ2"
      }
    },
    (local.az3) = {
      availability_zone_id = local.az3
      cidr_block           = "10.0.102.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ3"
      }
    }
  }
}

#### CLOUD INFRA ####

module "cloud_vpc" {
  source   = "../vpc/modules/vpc_v3"
  vpc_cidr = "10.0.0.0/16"
  igw      = true
  vpc_tags = {
    "Name" : "Cloud Prem VPC"
  }
}


module "cloud_app_rtb" {
  source = "../vpc/modules/subnet"

  vpc_id      = module.cloud_vpc.vpc_id
  cidr_block  = local.cloud_app_subnets[local.az_ids[0]].cidr_block
  az_id       = local.cloud_app_subnets[local.az_ids[0]].availability_zone_id
  subnet_tags = local.cloud_app_subnets[local.az_ids[0]].tags
  routes = {
    "fck_nat" : {
      destination_cidr_block = "0.0.0.0/0"
      network_interface_id   = aws_network_interface.fck_nat_nic.id
    }
  }
}


module "cloud_app" {
  source   = "../vpc/modules/subnet"
  for_each = { for key, value in local.cloud_app_subnets : key => value if key != local.az_ids[0] }

  vpc_id         = module.cloud_vpc.vpc_id
  cidr_block     = each.value.cidr_block
  az_id          = each.value.availability_zone_id
  create_rtb     = false
  route_table_id = module.cloud_app_rtb.route_table_id
  subnet_tags    = each.value.tags
}


module "cloud_web_rtb" {
  source              = "../vpc/modules/subnet"
  vpc_id              = module.cloud_vpc.vpc_id
  cidr_block          = local.cloud_web_subnets[local.az_ids[0]].cidr_block
  az_id               = local.cloud_web_subnets[local.az_ids[0]].availability_zone_id
  subnet_tags         = local.cloud_web_subnets[local.az_ids[0]].tags
  public_ip_on_launch = true

  routes = {
    "igw" : {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = module.cloud_vpc.igw_id
    }
  }
}


module "cloud_web" {
  source   = "../vpc/modules/subnet"
  for_each = { for key, value in local.cloud_web_subnets : key => value if key != local.az_ids[0] }

  vpc_id              = module.cloud_vpc.vpc_id
  cidr_block          = each.value.cidr_block
  az_id               = each.value.availability_zone_id
  create_rtb          = false
  route_table_id      = module.cloud_web_rtb.route_table_id
  subnet_tags         = each.value.tags
  public_ip_on_launch = true
}
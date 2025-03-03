locals {
  az_ids = ["euc1-az1", "euc1-az2", "euc1-az3"]

  cloud_db_subnets = {
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

  cloud_app_subnets = {
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

  cloud_web_subnets = {
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

#### CLOUD INFRA ####

module "cloud_vpc" {
  source   = "../vpc/modules/vpc_v3"
  vpc_cidr = "10.0.0.0/16"
  igw      = true
  vpc_tags = {
    "Name" : "Cloud Prem VPC"
  }
}


module "cloud_db_rtb" {
  source = "../vpc/modules/subnet"

  vpc_id     = module.cloud_vpc.vpc_id
  cidr_block = local.cloud_db_subnets[local.az_ids[0]].cidr_block
  az_id      = local.cloud_db_subnets[local.az_ids[0]].availability_zone_id
}


module "cloud_db" {
  source   = "../vpc/modules/subnet"
  for_each = { for key, value in local.cloud_db_subnets : key => value if key != local.az_ids[0] }

  vpc_id         = module.cloud_vpc.vpc_id
  cidr_block     = each.value.cidr_block
  az_id          = each.value.availability_zone_id
  create_rtb     = false
  route_table_id = module.cloud_db_rtb.route_table_id
}


module "cloud_app" {
  source   = "../vpc/modules/subnet"
  for_each = local.cloud_app_subnets

  vpc_id         = module.cloud_vpc.vpc_id
  cidr_block     = each.value.cidr_block
  az_id          = each.value.availability_zone_id
  create_rtb     = false
  route_table_id = module.cloud_db_rtb.route_table_id
}


module "cloud_web_rtb" {
  source      = "../vpc/modules/subnet"
  vpc_id      = module.cloud_vpc.vpc_id
  cidr_block  = local.cloud_web_subnets[local.az_ids[0]].cidr_block
  az_id       = local.cloud_web_subnets[local.az_ids[0]].availability_zone_id
  subnet_tags = local.cloud_web_subnets[local.az_ids[0]].tags

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

  vpc_id         = module.cloud_vpc.vpc_id
  cidr_block     = each.value.cidr_block
  az_id          = each.value.availability_zone_id
  create_rtb     = false
  route_table_id = module.cloud_web_rtb.route_table_id
  subnet_tags    = each.value.tags
}


module "ssm" {
  source              = "../vpc/modules/vpc_endpoint"
  vpc_id              = module.cloud_vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  private_dns_enabled = true
  subnet_ids          = [for az_id in [local.az_ids[1], local.az_ids[2]] : module.cloud_db[az_id].subnet_id]

  tags = {
    "Name" = "SSM EP"
  }
}

module "ssm_messages" {
  source       = "../vpc/modules/vpc_endpoint"
  vpc_id       = module.cloud_vpc.vpc_id
  service_name = "com.amazonaws.${var.region}.ssmmessages"

  private_dns_enabled = true
  subnet_ids          = [for az_id in [local.az_ids[1], local.az_ids[2]] : module.cloud_db[az_id].subnet_id]

  security_group_ids = [module.ssm.sg_id]

  tags = {
    "Name" = "SSM MESSAGES EP"
  }
}
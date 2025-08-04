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
  igw      = false
  vpc_tags = {
    "Name" : "Cloud Prem VPC"
  }
}


module "cloud_db" {
  source   = "../vpc/modules/subnet"
  for_each = local.cloud_db_subnets

  vpc_id      = module.cloud_vpc.vpc_id
  cidr_block  = each.value.cidr_block
  az_id       = each.value.availability_zone_id
  subnet_tags = each.value.tags
}




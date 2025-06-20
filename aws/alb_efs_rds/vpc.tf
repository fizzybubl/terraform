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

  subnet_tags = local.cloud_db_subnets[local.az_ids[0]].tags
}


module "cloud_db" {
  source   = "../vpc/modules/subnet"
  for_each = { for key, value in local.cloud_db_subnets : key => value if key != local.az_ids[0] }

  vpc_id         = module.cloud_vpc.vpc_id
  cidr_block     = each.value.cidr_block
  az_id          = each.value.availability_zone_id
  create_rtb     = false
  route_table_id = module.cloud_db_rtb.route_table_id
  subnet_tags    = each.value.tags
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



module "ssm_sg" {
  source = "../ec2/modules/security_groups"

  name        = "ssm-sg"
  vpc_id      = module.cloud_vpc.vpc_id
  description = "SG for SSM EP"

  ingress_rules = {
    "voc_ingress" = {
      cidr_block  = module.cloud_vpc.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All from VPC"
      protocol    = -1
    }
  }

  egress_rules = {
    "vpc_egress" = {
      cidr_block  = module.cloud_vpc.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All to vpc"
      protocol    = -1
    }
  }
}


module "ssm" {
  for_each            = toset(["ssm", "ssmmessages", "ec2messages"])
  source              = "../vpc/modules/vpc_endpoint"
  private_dns_enabled = true
  default_sg          = false
  security_group_ids  = [module.ssm_sg.sg_id]
  service_name        = "com.amazonaws.${var.region}.${each.value}"
  vpc_id              = module.cloud_vpc.vpc_id
  subnet_ids          = [for key, value in module.cloud_app: value.subnet_id]
}
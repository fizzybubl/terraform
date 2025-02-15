locals {
  on_prem_db_subnets = {
    "db-euc1-az1" = {
      availability_zone_id = "euc1-az1"
      cidr_block           = "10.100.1.0/24"
      tags = {
        "Name" : "Private Subnet DB AZ1"
      }
    },
    "db-euc1-az2" = {
      availability_zone_id = "euc1-az2"
      cidr_block           = "10.100.2.0/24"
      tags = {
        "Name" : "Private Subnet DB AZ2"
      }
    },
    "db-euc1-az3" = {
      availability_zone_id = "euc1-az3"
      cidr_block           = "10.100.3.0/24"
      tags = {
        "Name" : "Private Subnet DB AZ3"
      }
    }
  }

  on_prem_app_subnets = {
    "app-euc1-az1" = {
      availability_zone_id = "euc1-az1"
      cidr_block           = "10.100.10.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ1"
      }
    },
    "app-euc1-az2" = {
      availability_zone_id = "euc1-az2"
      cidr_block           = "10.100.11.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ2"
      }
    },
    "app-euc1-az3" = {
      availability_zone_id = "euc1-az3"
      cidr_block           = "10.100.12.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ3"
      }
    }

  }

  on_prem_web_subnets = {
    "web-euc1-az1" = {
      availability_zone_id = "euc1-az1"
      cidr_block           = "10.100.100.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ1"
      }
    },
    "web-euc1-az2" = {
      availability_zone_id = "euc1-az2"
      cidr_block           = "10.100.101.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ2"
      }
    },
    "web-euc1-az3" = {
      availability_zone_id = "euc1-az3"
      cidr_block           = "10.100.102.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ3"
      }
    }
  }

  cloud_db_subnets = {
    "db-euc1-az1" = {
      availability_zone_id = "euc1-az1"
      cidr_block           = "10.0.1.0/24"
      tags = {
        "Name" : "Private Subnet DB AZ1"
      }
    },
    "db-euc1-az2" = {
      availability_zone_id = "euc1-az2"
      cidr_block           = "10.0.2.0/24"
      tags = {
        "Name" : "Private Subnet DB AZ2"
      }
    },
    "db-euc1-az3" = {
      availability_zone_id = "euc1-az3"
      cidr_block           = "10.0.3.0/24"
      tags = {
        "Name" : "Private Subnet DB AZ3"
      }
    }
  }

  cloud_app_subnets = {
    "app-euc1-az1" = {
      availability_zone_id = "euc1-az1"
      cidr_block           = "10.0.10.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ1"
      }
    },
    "app-euc1-az2" = {
      availability_zone_id = "euc1-az2"
      cidr_block           = "10.0.11.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ2"
      }
    },
    "app-euc1-az3" = {
      availability_zone_id = "euc1-az3"
      cidr_block           = "10.0.12.0/24"
      tags = {
        "Name" : "Private Subnet APP AZ3"
      }
    }

  }

  cloud_web_subnets = {
    "web-euc1-az1" = {
      availability_zone_id = "euc1-az1"
      cidr_block           = "10.0.100.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ1"
      }
    },
    "web-euc1-az2" = {
      availability_zone_id = "euc1-az2"
      cidr_block           = "10.0.101.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ2"
      }
    },
    "web-euc1-az3" = {
      availability_zone_id = "euc1-az3"
      cidr_block           = "10.0.102.0/24"
      tags = {
        "Name" : "Public Subnet Web AZ3"
      }
    }
  }

  on_prem_private_routes_associations = concat([for key, value in local.on_prem_db_subnets: "db:${key}"], 
                                               [for key, value in local.on_prem_app_subnets: "db:${key}"])
  on_prem_public_routes_associations = concat([for key, value in local.on_prem_web_subnets: "web:${key}"])
  cloud_private_routes_associations = concat([for key, value in local.cloud_db_subnets: "db:${key}"], 
                                               [for key, value in local.cloud_app_subnets: "db:${key}"])
  cloud_public_routes_associations = concat([for key, value in local.cloud_web_subnets: "web:${key}"])
}



module "on_prem" {
  source   = "../vpc/modules/vpc_v2"
  vpc_cidr = "10.100.0.0/16"
  vpc_tags = {
    "Name" : "On Prem VPC"
  }

  natgw = false

  public_subnets  = local.on_prem_web_subnets
  private_subnets = merge(local.on_prem_app_subnets, local.on_prem_db_subnets)

  private_route_tables = {
    "db" : {
      tags = { "Name" : "DB Route Table" }
    }
  }

  private_routes_associations = local.on_prem_private_routes_associations
  public_routes_associations = local.on_prem_public_routes_associations

  public_route_tables = {
    "web" : {
      tags = { "Name" : "Web Route Table" }
    }
  }

  public_routes = {
    "internet" : {
      destination_cidr_block = "0.0.0.0/0",
      route_table            = "web"
    }
  }
}


module "cloud" {
  source   = "../vpc/modules/vpc_v2"
  vpc_cidr = "10.0.0.0/16"
  vpc_tags = {
    "Name" : "Cloud VPC"
  }

  natgw = false

  public_subnets  = local.cloud_web_subnets
  private_subnets = merge(local.cloud_app_subnets, local.cloud_db_subnets)

  private_route_tables = {
    "db" : {
      tags = { "Name" : "DB Route Table" }
    }
  }

  private_routes_associations = local.cloud_private_routes_associations
  public_routes_associations = local.cloud_public_routes_associations

  public_route_tables = {
    "web" : {
      tags = { "Name" : "Web Route Table" }
    }
  }

  public_routes = {
    "internet" : {
      destination_cidr_block = "0.0.0.0/0",
      route_table            = "web"
    }
  }
}
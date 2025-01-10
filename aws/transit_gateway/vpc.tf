module "prod" {
  source = "../vpc/modules/vpc"
  vpc_data = {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
      "Name" : "PROD"
    }
  }

  private_subnets_input = [
    {
      availability_zone = "eu-central-1a"
      cidr_block        = "10.0.0.0/24"
      tags = {
        "Name" : "Private Instance Subnet PROD"
      }
    },
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.0.1.0/24"
      tags = {
        "Name" : "Private Subnet PROD TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.0.2.0/24"
      tags = {
        "Name" : "Private Subnet PROD TGW 1c"
      }
    }
  ]

  public_subnets_input = []
}


module "pre_prod" {
  source = "../vpc/modules/vpc"
  vpc_data = {
    cidr_block       = "10.1.0.0/16"
    instance_tenancy = "default"
    tags = {
      "Name" : "PREPROD"
    }
  }

  private_subnets_input = [
    {
      availability_zone = "eu-central-1a"
      cidr_block        = "10.1.0.0/24"
      tags = {
        "Name" : "Private Subnet Instance PREPROD"
      }
    },
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.1.1.0/24"
      tags = {
        "Name" : "Private Subnet PREPROD TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.1.2.0/24"
      tags = {
        "Name" : "Private Subnet PREPROD TGW 1c"
      }
    }
  ]

  public_subnets_input = []
}


module "stg" {
  source = "../vpc/modules/vpc"
  vpc_data = {
    cidr_block       = "10.2.0.0/16"
    instance_tenancy = "default"
    tags = {
      "Name" : "STG"
    }
  }

  private_subnets_input = [
    {
      availability_zone = "eu-central-1a"
      cidr_block        = "10.2.0.0/24"
      tags = {
        "Name" : "Private Subnet Instance STG"
      }
    },
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.2.1.0/24"
      tags = {
        "Name" : "Private Subnet STG TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.2.2.0/24"
      tags = {
        "Name" : "Private Subnet STG TGW 1c"
      }
    }
  ]

  public_subnets_input = []
}


module "dev" {
  source = "../vpc/modules/vpc"
  vpc_data = {
    cidr_block       = "10.3.0.0/16"
    instance_tenancy = "default"
    tags = {
      "Name" : "DEV"
    }
  }

  private_subnets_input = [
    {
      availability_zone = "eu-central-1a"
      cidr_block        = "10.3.0.0/24"
      tags = {
        "Name" : "Private Subnet Instance Dev"
      }
    },
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.3.1.0/24"
      tags = {
        "Name" : "Private Subnet DEV TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.3.2.0/24"
      tags = {
        "Name" : "Private Subnet DEV TGW 1c"
      }
    }
  ]

  public_subnets_input = []
}


module "dmz" {
  source = "../vpc/modules/vpc"
  vpc_data = {
    cidr_block       = "10.100.0.0/16"
    instance_tenancy = "default"
    tags = {
      "Name" : "DMZ"
    }
  }

  private_subnets_input = []
  public_subnets_input = [
    {
      availability_zone = "eu-central-1a"
      cidr_block        = "10.100.200.0/24"
      tags = {
        "Name" : "Private Subnet Instance DMZ"
      }
    },
    {
      availability_zone = "eu-central-1b"
      cidr_block        = "10.100.201.0/24"
      tags = {
        "Name" : "Private Subnet DMZ TGW 1b"
      }
    },
    {
      availability_zone = "eu-central-1c"
      cidr_block        = "10.100.202.0/24"
      tags = {
        "Name" : "Private Subnet DMZ TGW 1c"
      }
    }
  ]
}
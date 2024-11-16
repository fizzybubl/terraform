locals {
  public_internet = "0.0.0.0/0"
  tags = {
    Group = "Terraform"
  }

  vpc_input = {
    service = {
      private_subnets_input = {
        subnets_data = [
          {
            availability_zone = "eu-central-1a"
            cidr_block        = "10.0.0.0/24"
          },
          {
            availability_zone = "eu-central-1b",
            cidr_block        = "10.0.1.0/24"
          },
          {
            availability_zone = "eu-central-1c",
            cidr_block        = "10.0.2.0/24"
          }
        ],
        subnets_access_type = "Private Subnet"
      }

      public_subnets_input = {
        subnets_data = [
          {
            availability_zone = "eu-central-1a"
            cidr_block        = "10.0.200.0/24"
          },
          {
            availability_zone = "eu-central-1b",
            cidr_block        = "10.0.201.0/24"
          },
          {
            availability_zone = "eu-central-1c",
            cidr_block        = "10.0.202.0/24"
          }
        ],
        subnets_access_type = "Public Subnet"
      }
      vpc_data = {
        cidr_block       = "10.0.0.0/16"
        name             = "Service VPC"
        instance_tenancy = "default"
      }
    }

    client = {
      private_subnets_input = {
        subnets_data = [
          {
            availability_zone = "eu-central-1a"
            cidr_block        = "100.64.0.0/24"
          },
          {
            availability_zone = "eu-central-1b",
            cidr_block        = "100.64.1.0/24"
          },
          {
            availability_zone = "eu-central-1c",
            cidr_block        = "100.64.2.0/24"
          }
        ],
        subnets_access_type = "Private Subnet"
      }

      public_subnets_input = {
        subnets_data = [
          {
            availability_zone = "eu-central-1a"
            cidr_block        = "100.64.200.0/24"
          },
          {
            availability_zone = "eu-central-1b",
            cidr_block        = "100.64.201.0/24"
          },
          {
            availability_zone = "eu-central-1c",
            cidr_block        = "100.64.202.0/24"
          }
        ],
        subnets_access_type = "Public Subnet"
      }
      vpc_data = {
        cidr_block       = "100.64.0.0/16"
        name             = "Client VPC"
        instance_tenancy = "default"
      }
    }
  }
}


module "vpc" {
  for_each              = local.vpc_input
  source                = "./modules/vpc"
  private_subnets_input = each.value.private_subnets_input
  public_subnets_input  = each.value.public_subnets_input
  vpc_data              = each.value.vpc_data
}
module "vpc" {
  source = "../../vpc/modules/vpc"
  region = var.region
  private_subnets_input = [
    {
      availability_zone = "eu-west-1a"
      cidr_block        = "10.0.0.0/24"
    },
    {
      availability_zone = "eu-west-1b",
      cidr_block        = "10.0.1.0/24"
    },
    {
      availability_zone = "eu-west-1c",
      cidr_block        = "10.0.2.0/24"
    }
  ]

  public_subnets_input =  [
    {
      availability_zone = "eu-west-1a"
      cidr_block        = "10.0.200.0/24"
    },
    {
      availability_zone = "eu-west-1b",
      cidr_block        = "10.0.201.0/24"
    },
    {
      availability_zone = "eu-west-1c",
      cidr_block        = "10.0.202.0/24"
    }
  ]

  providers = {
    aws = aws
  }
}
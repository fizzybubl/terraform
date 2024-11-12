variable "vpc_data" {
  type = object({
    cidr_block       = string
    instance_tenancy = string,
    name = string
  })
  default = { cidr_block = "10.0.0.0/16", instance_tenancy = "default", name = "Custom VPC" }
}


variable "private_subnets_input" {
  type = object({
    subnets_data = list(map(string))
    subnets_access_type = string
  })
  default = {
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
}


variable "public_subnets_input" {
   type = object({
    subnets_data = list(map(string))
    subnets_access_type = string
  })
  default = {
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
}

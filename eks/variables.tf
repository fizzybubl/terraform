variable "authorised_ips" {
  type        = set(string)
  description = "IPs from which to allow traffic"
}

variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "stage" {
  type    = string
  default = "v1"
}

variable "vpc_data" {
  type = object({
    cidr_block       = string
    instance_tenancy = string
  })
  default = { cidr_block = "10.0.0.0/16", instance_tenancy = "default" }
}


variable "private_subnets_input" {
  type = list(map(string))
  default = [
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
  ]
}


variable "public_subnets_input" {
  type = list(map(string))
  default = [
    {
      availability_zone = "eu-central-1a"
      cidr_block        = "10.200.0.0/24"
    },
    {
      availability_zone = "eu-central-1b",
      cidr_block        = "10.200.1.0/24"
    },
    {
      availability_zone = "eu-central-1c",
      cidr_block        = "10.200.2.0/24"
    }
  ]
}


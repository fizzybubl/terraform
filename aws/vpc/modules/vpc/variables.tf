variable "profile" {
  type    = string
  default = "default"
}


variable "vpc_data" {
  type = object({
    cidr_block       = string
    instance_tenancy = string
    tags             = map(string)
  })
  default = { cidr_block = "10.0.0.0/16", instance_tenancy = "default", tags = null }
}


variable "private_subnets_input" {
  type = list(object({
    availability_zone = string
    cidr_block        = string
    tags              = map(string)
  }))
  default = [
    {
      availability_zone = "eu-central-1a"
      cidr_block        = "10.0.0.0/24"
      tags              = null
    },
    {
      availability_zone = "eu-central-1b",
      cidr_block        = "10.0.1.0/24"
      tags              = null
    },
    {
      availability_zone = "eu-central-1c",
      cidr_block        = "10.0.2.0/24"
      tags              = null
    }
  ]
}


variable "public_subnets_input" {
  type = list(object({
    availability_zone = string
    cidr_block        = string
    tags              = map(string)
  }))
  default = [
    {
      availability_zone = "eu-central-1a"
      cidr_block        = "10.0.200.0/24"
      tags              = null
    },
    {
      availability_zone = "eu-central-1b",
      cidr_block        = "10.0.201.0/24"
      tags              = null
    },
    {
      availability_zone = "eu-central-1c",
      cidr_block        = "10.0.202.0/24"
      tags              = null
    }
  ]
}


variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "natgw" {
  type    = bool
  default = false
}

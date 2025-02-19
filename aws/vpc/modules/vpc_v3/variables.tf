variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "instance_tenancy" {
  type    = string
  default = "default"
}


variable "vpc_tags" {
  type    = map(string)
  default = null
}


variable "enable_dns_support" {
  type    = bool
  default = true
}


variable "enable_dns_hostnames" {
  type    = bool
  default = true
}


variable "igw" {
  type    = bool
  default = true
}

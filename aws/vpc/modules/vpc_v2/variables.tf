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


variable "vpc_id" {
  type    = string
  default = null
}


variable "private_subnets" {
  type = map(object({
    availability_zone_id = optional(string)
    availability_zone    = optional(string)
    cidr_block           = string
    tags                 = map(string)
  }))
  default = {}
}


variable "public_subnets" {
  type = map(object({
    availability_zone_id = optional(string)
    availability_zone    = optional(string)
    cidr_block           = string
    tags                 = map(string)
  }))
  default = {}
}

#### NAT GATEWAY ####
variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "natgw" {
  type    = bool
  default = false
}



#### PUBLIC ROUTE TABLE ####
variable "public_route_tables" {
  type = map(object({
    vpc_id = optional(string)
    tags   = map(string)
  }))
  default = {}
}


variable "public_routes" {
  type = map(object({
    route_table                 = string
    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
    destination_prefix_list_id  = optional(string)
    virtual_private_gateway_id  = optional(string)
    internet_gateway_id         = optional(string)
    transit_gateway_id          = optional(string)
    vpc_peering_connection_id   = optional(string)
    network_interface_id        = optional(string)
    vpc_endpoint_id             = optional(string)
    egress_only_gateway_id      = optional(string)
  }))
  default = {}
}


variable "public_routes_associations" {
  type    = set(any)
  default = []
}


#### PRIVATE ROUTE TABLE ####
variable "private_route_tables" {
  type = map(object({
    vpc_id = optional(string)
    tags   = map(string)
  }))
  default = {}
}

variable "private_routes" {
  type = map(object({
    route_table                 = string
    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
    destination_prefix_list_id  = optional(string)
    virtual_private_gateway_id  = optional(string)
    internet_gateway_id         = optional(string)
    transit_gateway_id          = optional(string)
    vpc_peering_connection_id   = optional(string)
    network_interface_id        = optional(string)
    vpc_endpoint_id             = optional(string)
    egress_only_gateway_id      = optional(string)
  }))
  default = {}
}


variable "private_routes_associations" {
  type    = set(any)
  default = []
}
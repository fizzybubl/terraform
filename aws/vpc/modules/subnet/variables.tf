variable "vpc_id" {
  type = string
}


variable "cidr_block" {
  type = string
}


variable "ipv6_cidr_block" {
  type    = string
  default = null
}

variable "az_id" {
  type    = string
  default = null
}


variable "az_name" {
  type    = string
  default = null
}


variable "create_rtb" {
  type    = bool
  default = true
}

variable "public_ip_on_launch" {
  type    = bool
  default = false
}

variable "subnet_tags" {
  type    = map(string)
  default = null
}


variable "route_table_id" {
  type    = string
  default = ""
}


variable "routes" {
  type = map(object({
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


variable "natgw" {
  type    = bool
  default = false
}


variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "network_acl_id" {
  type    = string
  default = null
}


variable "create_network_acl" {
  type    = bool
  default = false
}


variable "ingress_acl" {
  type = map(object({
    rule_number     = optional(string)
    protocol        = optional(string)
    rule_action     = optional(string)
    cidr_block      = optional(string)
    from_port       = optional(string)
    to_port         = optional(string)
    ipv6_cidr_block = optional(string)
    icmp_type       = optional(number)
    icmp_code       = optional(number)
  }))

  default = {}
}


variable "egress_acl" {
  type = map(object({
    rule_number     = optional(string)
    protocol        = optional(string)
    rule_action     = optional(string)
    cidr_block      = optional(string)
    from_port       = optional(string)
    to_port         = optional(string)
    ipv6_cidr_block = optional(string)
    icmp_type       = optional(number)
    icmp_code       = optional(number)
  }))

  default = {}
}
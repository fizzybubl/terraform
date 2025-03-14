variable "service_name" {
  type = string
}


variable "type" {
  type    = string
  default = "Interface"
}

variable "subnet_ids" {
  type    = list(string)
  default = null
}


variable "security_group_ids" {
  type    = list(string)
  default = null
}


variable "tags" {
  type    = map(string)
  default = null
}


variable "private_dns_enabled" {
  type    = bool
  default = false
}

variable "vpc_id" {
  type = string
}


variable "route_table_ids" {
  type    = list(string)
  default = null
}


variable "default_sg" {
  type    = bool
  default = true
}
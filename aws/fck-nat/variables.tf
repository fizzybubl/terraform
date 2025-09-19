variable "subnet_id" {
  type = string
}


variable "security_group_ids" {
  type = list(string)
}


variable "private_ip_list" {
  type = list(string)
}


variable "instance_type" {
  type    = string
  default = "t4g.nano"
}
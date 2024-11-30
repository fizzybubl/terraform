variable "vpc_id" {
  type = string
  default = ""
}


variable "route_table_ids" {
  type = list(string)
  default = [  ]
}


variable "subnet_ids" {
  type = list(string)
  default = [  ]
}


variable "region" {
  type    = string
  default = "eu-central-1"
}

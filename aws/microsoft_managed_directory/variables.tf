variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "profile" {
  type    = string
  default = "admin-dev"
}


variable "directory_type" {
  type    = string
  default = "SimpleAD"
}


variable "admin_password" {
  type      = string
  sensitive = true
}
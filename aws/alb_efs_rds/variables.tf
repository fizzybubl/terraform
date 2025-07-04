variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "profile" {
  type    = string
  default = "admin-dev"
}

variable "db_pw" {
  type      = object({ ssm_name = string, value = string })
  sensitive = true
}

variable "db_endpoint" {
  type = object({ ssm_name = string, value = string })
}

variable "db_name" {
  type = object({ ssm_name = string, value = string })
}

variable "db_user" {
  type = object({ ssm_name = string, value = string })
}

variable "db_root_pw" {
  type      = object({ ssm_name = string, value = string })
  sensitive = true
}
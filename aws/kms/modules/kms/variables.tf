variable "key_policy" {
  type = string
}


variable "enable_key_rotation" {
  type    = bool
  default = true
}


variable "rotation_period_in_days" {
  type    = number
  default = 365
}


variable "deletion_window_in_days" {
  type    = number
  default = 7
}


variable "customer_master_key_spec" {
  type    = string
  default = "SYMMETRIC_DEFAULT"
}


variable "key_usage" {
  type    = string
  default = "ENCRYPT_DECRYPT"
}


variable "description" {
  type    = string
  default = "Default description"
}


variable "multi_region" {
  type    = bool
  default = false
}


variable "alias" {
  type    = string
  default = "some_alias"
}


variable "replica" {
  type    = bool
  default = false
}


variable "primary_key_arn" {
  type = string
  default = null
}
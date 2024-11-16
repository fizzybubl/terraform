variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy resources"
}

variable "authorised_ips" {
  type        = set(string)
  description = "IPs from which to allow traffic"
}

variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "stage" {
  type    = string
  default = "v1"
}
variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy resources"
}

variable "authorised_ips" {
  type        = set(string)
  description = "IPs from which to allow traffic"
}

variable "instance_types" {
  type        = set(string)
  description = "Type of instance to use"
  default     = ["t2.micro", "t3.micro"]
}

variable "profile" {
  type = string
}

variable "region" {
  type = string
}
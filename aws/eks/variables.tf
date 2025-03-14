variable "authorised_ips" {
  type        = set(string)
  description = "IPs from which to allow traffic"
  default     = ["0.0.0.0/0"]
}


variable "profile" {
  type    = string
  default = "admin-dev"
}



variable "instance_type" {
  type    = string
  default = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Allowed values are ${join(",", ["t2.micro", "t3.micro"])}"
  }
}

variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "cluster_name" {
  type    = string
  default = "oidc-cluster"
}


variable "vpc_data" {
  type = object({
    cidr_block       = string
    instance_tenancy = string
  })
  default = { cidr_block = "10.0.0.0/16", instance_tenancy = "default" }
}


variable "eks_version" {
  type = string
  default = "1.31" 
}
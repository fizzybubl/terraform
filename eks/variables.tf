variable "authorised_ips" {
  type        = set(string)
  description = "IPs from which to allow traffic"
  default     = ["0.0.0.0/0"]
}


variable "profile" {
  type    = string
  default = "default"
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
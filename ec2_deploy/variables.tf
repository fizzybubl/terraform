variable "instance_type" {
  type    = string
  default = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Allowed values are ${join(",", ["t2.micro", "t3.micro"])}"
  }
}

variable "instance_image" {
  type    = string
  default = "ami-01dad638e8f31ab9a"
}

variable "subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}


variable "region" {
  type = string
  default = "eu-central-1"
}
 
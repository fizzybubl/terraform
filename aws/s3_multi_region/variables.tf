variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "second_region" {
  type    = string
  default = "eu-west-1"
}


variable "profile" {
  type    = string
  default = "root-admin"
}


variable "bucket" {
  type    = string
  default = "test-s3-module-custom"
}


variable "force_destroy" {
  type    = bool
  default = false
}


variable "tags" {
  type    = map(string)
  default = {}
}

variable "bucket_id" {
  type    = string
  default = null
}


variable "rules" {
  type = map(object({

  }))
  default = {}
}

variable "bucket_policy" {
  type    = any
  default = null
}
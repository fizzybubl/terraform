variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "profile" {
  type    = string
  default = "root-admin"
}


variable "bucket" {
  type = string
}


variable "force_destroy" {
  type = bool
  default = false
}


variable "tags" {
  type = map(string)
  default = {}
}


variable "versioning" {
  type = string
  default = "Disabled"
}


variable "block_public_acls" {
  type = bool
  default = false
}


variable "block_public_policy" {
  type = bool
  default = false
}


variable "ignore_public_acls" {
  type = bool
  default = false
}


variable "restrict_public_buckets" {
  type = bool
  default = false
}


variable "transfer_acceleration" {
  type = string
  default = "Suspended"
} 


variable "sse_alg" {
  type = string
  default = "AES256"
}


variable "key_arn" {
  type = string
  default = null
}
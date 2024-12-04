variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "profile" {
  type    = string
  default = "root-admin"
}


variable "bucket_id" {
  type = string
  default = null
}


variable "rules" {
  type = map(object({
    
  }))
}
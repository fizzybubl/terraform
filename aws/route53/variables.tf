variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "profile" {
  type    = string
  default = "root-admin"
}


variable "zone_name" {
  type    = string
  default = ""
}


variable "zone_id" {
  type    = string
  default = ""
}


variable "record_data" {
  type = map(object({
    ttl     = optional(string, null)
    type    = string
    records = list(string)
  }))
  default = {}
}


variable "alias_record_data" {
  type = map(object({
    type = string
    alias = object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    })
  }))
  default = {}
}
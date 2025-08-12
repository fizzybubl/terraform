variable "zone_name" {
  type    = string
  default = null
}


variable "zone_description" {
  type    = string
  default = null
}


variable "vpc_ids" {
  type    = list(object({ vpc_id = string, region = string }))
  default = []
}


variable "record_data" {
  type = map(object({
    name                    = string
    zone_id                 = optional(string)
    ttl                     = optional(string)
    type                    = optional(string)
    records                 = optional(list(string))
    failover_routing_policy = optional(object({ type = string }))
    geolocation_routing_policy = optional(object({
      continent   = optional(string),
      country     = optional(string),
      subdivision = optional(string)
    }))
    geoproximity_routing_policy = optional(object({
      aws_region       = optional(string),
      bias             = optional(number),
      coordinates      = optional(object({ latitude = string, longitude = string })),
      local_zone_group = optional(string)
    }))
    latency_routing_policy           = optional(object({ region = string }))
    weighted_routing_policy          = optional(object({ weight = number }))
    multivalue_answer_routing_policy = optional(string)
    health_check_id                  = optional(string)
    set_identifier                   = string
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, true)
    }))
  }))
  default = {}
}


variable "dnssec_ksk" {
  description = " Config of the key used to verify the Zone Signing Keys in DNSKEY records."
  type = object({
    name    = string
    arn     = string
    zone_id = optional(string)
    status  = optional(string, "ACTIVE")
  })
  default = null
}

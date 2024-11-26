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
    ttl                              = optional(string, null)
    type                             = string
    records                          = list(string)
    failover_routing_policy          = optional(object({ type = string }), null)
    geolocation_routing_policy       = optional(object({ continent = string, country = string, subdivision = string }), null)
    geoproximity_routing_policy      = optional(object({ aws_region = string, bias = number, coordinates = object({ latitude = string, longitude = string }), local_zone_group = string }), null)
    latency_routing_policy           = optional(object({ region = string }), null)
    weighted_routing_policy          = optional(object({ weight = number }), null)
    multivalue_answer_routing_policy = bool
    alias = object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    })
  }))
  default = {}
}

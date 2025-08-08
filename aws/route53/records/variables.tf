variable "record_data" {
  type = map(object({
    name                             = string
    zone_id                          = string
    ttl                              = optional(string, null)
    type                             = optional(string, null)
    records                          = optional(list(string), null)
    failover_routing_policy          = optional(object({ type = string }), null)
    geolocation_routing_policy       = optional(object({ continent = string, country = string, subdivision = string }), null)
    geoproximity_routing_policy      = optional(object({ aws_region = string, bias = number, coordinates = object({ latitude = string, longitude = string }), local_zone_group = string }), null)
    latency_routing_policy           = optional(object({ region = string }), null)
    weighted_routing_policy          = optional(object({ weight = number }), null)
    multivalue_answer_routing_policy = optional(string, null)
    health_check_id                  = optional(string, null)
    set_identifier                   = string
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    }), null)
  }))
  default = {}
}

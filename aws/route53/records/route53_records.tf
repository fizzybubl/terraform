resource "aws_route53_record" "record" {
  for_each = var.record_data
  zone_id  = each.value.zone_id
  name     = each.key
  type     = each.value.type
  ttl      = each.value.ttl
  records  = each.value.records
  set_identifier = each.value.set_identifier

  dynamic "failover_routing_policy" {
    for_each = each.value.failover_routing_policy != null ? ["failover_routing_policy"] : []
    content {
      type = each.value.failover_routing_policy.type
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = each.value.geolocation_routing_policy != null ? ["geolocation_routing_policy"] : []
    content {
      continent   = each.value.geolocation_routing_policy.continent
      country     = each.value.geolocation_routing_policy.country
      subdivision = each.value.geolocation_routing_policy.subdivision
    }
  }

  dynamic "geoproximity_routing_policy" {
    for_each = each.value.geoproximity_routing_policy != null ? ["geoproximity_routing_policy"] : []
    content {
      aws_region = each.value.geoproximity_routing_policy.aws_region
      bias       = each.value.geoproximity_routing_policy.bias
      coordinates {
        latitude  = each.value.geoproximity_routing_policy.coordinates.latitude
        longitude = each.value.geoproximity_routing_policy.coordinates.longitude
      }
      local_zone_group = each.value.geoproximity_routing_policy.local_zone_group
    }
  }

  dynamic "latency_routing_policy" {
    for_each = each.value.latency_routing_policy != null ? ["latency_routing_policy"] : []
    content {
      region = each.value.latency_routing_policy.region
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = each.value.weighted_routing_policy != null ? ["weighted_routing_policy"] : []
    content {
      weight = each.value.weighted_routing_policy.weight
    }
  }

  multivalue_answer_routing_policy = each.value.multivalue_answer_routing_policy

  dynamic "alias" {
    for_each = each.value.alias != null ? ["alias"] : []
    content {
      name                   = each.value.alias.name
      zone_id                = each.value.alias.zone_id
      evaluate_target_health = each.value.alias.evaluate_target_health
    }
  }
}

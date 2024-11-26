locals {
  zone_id = length(var.zone_name) > 0 ? aws_route53_zone.main[0].zone_id : var.zone_id
}


resource "aws_route53_zone" "main" {
  count = length(var.zone_name) > 0 ? 1 : 0
  name  = var.zone_name
}


resource "aws_route53_record" "record" {
  for_each = var.record_data
  zone_id  = local.zone_id
  name     = each.key
  type     = each.value.type
  ttl      = each.value.ttl
  records  = each.value.records

  # cidr_routing_policy {
  #   for_each = each.value.cidr_routing_policy
    
  # }

  dynamic "failover_routing_policy" {
    for_each = each.value.failover_routing_policy
    iterator = "routing_policy"
    content {
      type = routing_policy.value.type
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = each.value.geolocation_routing_policy
    iterator = "routing_policy"
    content {
      continent = routing_policy.value.continent
      country = routing_policy.value.country
      subdivision = routing_policy.value.subdivision
    }
  }

  dynamic "geoproximity_routing_policy" {
    for_each = each.value.geoproximity_routing_policy
    iterator = "routing_policy"
    content {
      aws_region = routing_policy.value.aws_region
      bias = routing_policy.value.bias
      coordinates = {
        latitude = routing_policy.value.coordinates.latitude
        longitude = routing_policy.value.coordinates.longitude
      }
      local_zone_group = routing_policy.value.local_zone_group
    }
  }

  dynamic "latency_routing_policy" {
    for_each = each.value.latency_routing_policy
    iterator = "routing_policy"
    content {
      region = routing_policy.value.region
    }
  }

  dynamic "multivalue_answer_routing_policy"{
    for_each = each.value.multivalue_answer_routing_policy
    iterator = "routing_policy"
    content {
      weight = routing_policy.value.weight
    }
  }

  weighted_routing_policy = each.value.weighted_routing_policy
}


resource "aws_route53_record" "alias_record" {
  for_each = var.record_data
  zone_id  = local.zone_id
  name     = each.key
  type     = each.value.type

  alias {
    name                   = each.value.alias.name
    zone_id                = each.value.alias.zone_id
    evaluate_target_health = each.value.alias.evaluate_target_health
  }
}
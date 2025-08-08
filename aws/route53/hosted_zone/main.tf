resource "aws_route53_zone" "this" {
  count   = var.zone_name != null ? 1 : 0
  name    = var.zone_name
  comment = var.zone_description

  dynamic "vpc" {
    for_each = var.vpc_ids

    content {
      vpc_id = vpc.value.vpc_id
      vpc_region = vpc.value.region
    }
  }
}


resource "aws_route53_record" "this" {
  for_each       = var.record_data
  zone_id        = coalesce(each.value.zone_id, try(aws_route53_zone.this[0].zone_id, null))
  name           = each.value.name
  type           = each.value.type
  ttl            = each.value.ttl
  records        = each.value.records
  set_identifier = each.value.set_identifier
  health_check_id = each.value.health_check_id

  dynamic "failover_routing_policy" {
    iterator = frp
    for_each = each.value.failover_routing_policy != null ? [each.value.failover_routing_policy] : []
    content {
      type = frp.value.type
    }
  }

  dynamic "geolocation_routing_policy" {
    iterator = grp
    for_each = each.value.geolocation_routing_policy != null ? [each.value.geolocation_routing_policy] : []
    content {
      continent   = grp.value.continent
      country     = grp.value.country
      subdivision = grp.value.subdivision
    }
  }

  dynamic "geoproximity_routing_policy" {
    iterator = gpxrp
    for_each = each.value.geoproximity_routing_policy != null ? [each.value.geoproximity_routing_policy] : []
    content {
      aws_region = gpxrp.value.aws_region
      bias       = gpxrp.value.bias
      coordinates {
        latitude  = gpxrp.value.coordinates.latitude
        longitude = gpxrp.value.coordinates.longitude
      }
      local_zone_group = gpxrp.value.local_zone_group
    }
  }

  dynamic "latency_routing_policy" {
    iterator = lrp
    for_each = each.value.latency_routing_policy != null ? [each.value.latency_routing_policy] : []
    content {
      region = lrp.value.region
    }
  }

  dynamic "weighted_routing_policy" {
    iterator = wrp
    for_each = each.value.weighted_routing_policy != null ? [each.value.weighted_routing_policy] : []
    content {
      weight = wrp.value.weight
    }
  }

  multivalue_answer_routing_policy = each.value.multivalue_answer_routing_policy

  dynamic "alias" {
    for_each = each.value.alias != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}



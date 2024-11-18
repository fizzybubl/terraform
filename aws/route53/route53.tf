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
output "zone_id" {
  value = try(aws_route53_zone.this[0].zone_id, null)
}
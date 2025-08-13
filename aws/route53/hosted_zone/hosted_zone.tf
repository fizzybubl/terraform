resource "aws_route53_zone" "this" {
  count   = var.zone_name != null ? 1 : 0
  name    = var.zone_name
  comment = var.zone_description

  dynamic "vpc" {
    for_each = var.vpc_ids

    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.region
    }
  }
}

resource "aws_route53_key_signing_key" "this" {
  count                      = var.dnssec_ksk != null ? 1 : 0
  hosted_zone_id             = coalesce(var.dnssec_ksk.zone_id, try(aws_route53_zone.this[0].zone_id, null))
  key_management_service_arn = var.dnssec_ksk.arn
  name                       = var.dnssec_ksk.name
  status                     = var.dnssec_ksk.status
}

resource "aws_route53_hosted_zone_dnssec" "this" {
  count          = var.dnssec_ksk != null ? 1 : 0
  hosted_zone_id = aws_route53_key_signing_key.this[0].hosted_zone_id
  depends_on = [
    aws_route53_key_signing_key.example
  ]
}

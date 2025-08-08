resource "aws_route53_zone" "this" {
  name    = var.zone_name
  comment = var.zone_description

  dynamic "vpc" {
    for_each = var.vpc_ids

    content {
      vpc_id = each.value
    }
  }
}

module "route53_hosted_zone" {
  source    = "../route53/hosted_zone"
  zone_name = "mtlsexample.online"
  providers = {
    aws = aws
  }
}


module "latency_routing_record" {
  source = "../route53/records"

  record_data = {
    "frankfurt_record" = {
      zone_id = module.route53_hosted_zone.hosted_zone.zone_id
      type = "A"
      set_identifier = "fra"
      latency_routing_policy = {
        region = var.region
      }
      alias = {
        zone_id                = aws_lb.alb.zone_id
        evaluate_target_health = true
        name                   = aws_lb.alb.dns_name
      }
    }
  }

  providers = {
    aws = aws
  }
}
locals {
  short_region = {
    "eu-central-1": "fra",
    "eu-west-1": "dub"
  }[var.region]
}


data "aws_route53_zone" "selected" {
  name         = "mtlsexample.online"
  private_zone = false
}


module "latency_routing_record" {
  source = "../../route53/records"

  record_data = {
    "test.mtlsexample.online" = {
      zone_id = data.aws_route53_zone.selected.zone_id
      type = "A"
      set_identifier = local.short_region
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
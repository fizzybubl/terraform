resource "aws_route53_zone" "public" {
  name = "mtlsexample.online"
}


resource "aws_route53_health_check" "active" {
  type              = "HTTP"
  port              = "80"
  resource_path     = "/index.html"
  failure_threshold = "3"
  request_interval  = 30
  ip_address        = aws_eip.public_ip.public_ip
}


resource "aws_route53_record" "active" {
  zone_id         = aws_route53_zone.public.id
  set_identifier  = "active"
  name            = "www.mtlsexample.online"
  type            = "A"
  ttl             = "60"
  health_check_id = aws_route53_health_check.active.id
  records         = [aws_eip.public_ip.public_ip]

  failover_routing_policy {
    type = "PRIMARY"
  }
}


resource "aws_route53_record" "passive" {
  zone_id        = aws_route53_zone.public.id
  set_identifier = "passive"
  name           = "www.mtlsexample.online"
  type           = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.failover.website_domain
    zone_id                = module.failover.bucket.hosted_zone_id
    evaluate_target_health = false
  }

  failover_routing_policy {
    type = "SECONDARY"
  }
}


resource "aws_route53_zone" "private" {
  name = "ireallylikedogs.com"

  vpc {
    vpc_id = data.aws_vpc.default.id
  }
}


resource "aws_route53_record" "private" {
  zone_id         = aws_route53_zone.public.id
  name            = "www.ireallylikedogs.com"
  type            = "A"
  ttl             = "60"
  health_check_id = aws_route53_health_check.active.id
  records         = ["1.1.1.1"]
}

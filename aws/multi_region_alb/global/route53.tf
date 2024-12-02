module "route53_hosted_zone" {
  source    = "../../route53/hosted_zone"
  zone_name = "mtlsexample.online"
  providers = {
    aws = aws
  }
}

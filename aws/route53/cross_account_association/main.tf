resource "aws_route53_vpc_association_authorization" "this" {
  provider = aws.r53_owner

  zone_id    = var.vpc_association.zone_id
  vpc_id     = var.vpc_association.vpc_id
  vpc_region = var.vpc_association.vpc_region
}

resource "aws_route53_zone_association" "this" {
  provider = aws.vpc_owner

  zone_id    = var.vpc_association.zone_id
  vpc_id     = var.vpc_association.vpc_id
  vpc_region = var.vpc_association.vpc_region
}
output "aws_route53_vpc_association_authorization_id" {
  description = "ID of Route53 VPC association authorizations"
  value       = aws_route53_vpc_association_authorization.this.id
}

output "aws_route53_zone_association_id" {
  description = "ID of Route53 VPC association"
  value       = aws_route53_zone_association.this.id
}

output "aws_route53_zone_association_owning_account" {
  description = "The account ID of the account that created the hosted zone."
  value       = aws_route53_zone_association.this.owning_account
}
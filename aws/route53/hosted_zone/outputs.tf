output "hosted_zone" {
  value = try(aws_route53_zone.this[0], null)
}


output "record_name" {
  value = {for k, v in aws_route53_record.this: k => v.name}
}


output "record_fqdn" {
  value = {for k, v in aws_route53_record.this: k => v.fqdn}
}
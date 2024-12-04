output "name_servers" {
  value = module.route53_hosted_zone.hosted_zone.name_servers
}
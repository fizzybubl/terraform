resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = var.lb_type
  internal           = var.internal
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.deletion_protection

  tags = var.lb_tags
}


module "target_groups" {
  source               = "./modules/target_groups"
  for_each             = var.target_groups
  name                 = each.value.name
  type                 = each.value.type
  port                 = each.value.port
  protocol             = each.value.protocol
  vpc_id               = each.value.vpc_id
  deregistration_delay = each.value.deregistration_delay

  healthcheck = {
    healthy_threshold = each.value.health_check.healthy_threshold
    enabled           = each.value.health_check.enable
    interval          = each.value.health_check.interval
    matcher           = each.value.health_check.matcher
    path              = each.value.health_check.path
    port              = each.value.health_check.port
    protocol          = each.value.health_check.protocol
    timeout           = each.value.health_check.timeout
  }

  stickiness = {
    type            = each.value.stickiness.type
    cookie_duration = each.value.stickiness.cookie_duration
    cookie_name     = each.value.stickiness.cookie_name
    enabled         = each.value.stickiness.enabled
  }
}


module "listeners" {
  source          = "./modules/listeners"
  for_each        = var.listeners
  port            = each.value.port
  protocol        = each.value.port
  ssl_policy      = each.value.ssl_policy
  certificate_arn = each.value.certificate_arn
  alpn_policy     = each.value.alpn_policy

  mutual_authentication = each.value.mutual_authentication
  cognito               = each.value.cognito
  oidc                  = each.value.oidc
  forward_tg            = each.value.forward_tg
  weighted_forward      = each.value.weighted_forward
}

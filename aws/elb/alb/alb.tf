locals {
  targets_to_listeners = { for key, value in var.listeners : key => {
    forward_tg : [for tg, value in var.target_groups : { arn = module.target_groups[tg].arn } if var.target_groups[tg].listener == key && var.target_groups[tg].weight == null]
    weighted_forward : [for tg, value in var.target_groups : { arn = module.target_groups[tg].arn  } if var.target_groups[tg].listener == key && var.target_groups[tg].weight != null],
    }
  }


}


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
  target_id            = each.value.target_id
  asg_name             = each.value.asg_name

  health_check = {
    healthy_threshold = each.value.health_check.healthy_threshold
    enabled           = each.value.health_check.enabled
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
  lb_arn          = aws_lb.this.arn
  for_each        = var.listeners
  port            = each.value.port
  protocol        = each.value.protocol
  ssl_policy      = each.value.ssl_policy
  certificate_arn = each.value.certificate_arn
  alpn_policy     = each.value.alpn_policy

  mutual_authentication = each.value.mutual_authentication
  cognito               = each.value.cognito
  oidc                  = each.value.oidc
  forward_tg            = concat(local.targets_to_listeners[each.key].forward_tg, coalesce(each.value.forward_tg, []))
  weighted_forward      = concat(local.targets_to_listeners[each.key].weighted_forward, coalesce(each.value.weighted_forward, []))
}

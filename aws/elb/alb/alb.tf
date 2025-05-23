resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = var.lb_type
  internal           = var.internal
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.deletion_protection

  tags = var.lb_tags
}


resource "aws_lb_target_group" "this" {
  for_each             = var.target_groups
  name                 = each.value.name
  target_type          = each.value.type
  port                 = each.value.port
  protocol             = each.value.protocol
  vpc_id               = each.value.vpc_id
  deregistration_delay = each.value.deregistration_delay

  health_check {
    healthy_threshold = each.value.health_check.healthy_threshold
    enabled           = each.value.health_check.enable
    interval          = each.value.health_check.interval
    matcher           = each.value.health_check.matcher
    path              = each.value.health_check.path
    port              = each.value.health_check.port
    protocol          = each.value.health_check.protocol
    timeout           = each.value.health_check.timeout
  }

  stickiness {
    type            = each.value.stickiness.type
    cookie_duration = each.value.stickiness.cookie_duration
    cookie_name     = each.value.stickiness.cookie_name
    enabled         = each.value.stickiness.enabled
  }
}


resource "aws_autoscaling_attachment" "this" {
  for_each               = var.target_groups
  lb_target_group_arn    = aws_lb_target_group.this[each.key].arn
  autoscaling_group_name = each.value.asg_name
}


resource "aws_lb_listener" "this" {
  for_each          = var.listeners
  load_balancer_arn = try(each.value.lb_arn, aws_lb.this.arn)
  port              = each.value.port
  protocol          = each.value.port
  ssl_policy        = each.value.ssl_policy
  certificate_arn   = each.value.certificate_arn
  alpn_policy       = each.value.alpn_policy


  dynamic "mutual_authentication" {
    for_each = try([each.value.mutual_authentication], [])
    content {
      mode            = mutual_authentication.value.mode
      trust_store_arn = mutual_authentication.value.trust_store_arn
    }
  }

  dynamic "default_action" {
    iterator = "cognito"
    for_each = each.value.cognito != null ? [each.value.cognito] : []
    content {
      type = "authenticate-cognito"
      authenticate_cognito {
        authentication_request_extra_params = cognito.value.authentication_request_extra_params
        on_unauthenticated_request          = cognito.value.on_unauthenticated_request
        scope                               = cognito.value.scopeabspath
        session_cookie_name                 = cognito.value.session_cookie_name
        session_timeout                     = cognito.value.session_timeout
        user_pool_arn                       = cognito.value.user_pool_arn
        user_pool_client_id                 = cognito.value.user_pool_client_id
        user_pool_domain                    = cognito.value.user_pool_domain
      }
    }
  }

  dynamic "default_action" {
    iterator = "oidc"
    for_each = each.value.oidc != null ? [each.value.oidc] : []
    content {
      type = "authenticate-oidc"
      authenticate_oidc {
        authorization_endpoint = oidc.value.authorization_endpoint
        client_id              = oidc.value.client_id
        client_secret          = oidc.value.client_secret
        issuer                 = oidc.value.issuer
        token_endpoint         = oidc.value.token_endpoint
        user_info_endpoint     = oidc.value.user_info_endpoint
      }
    }
  }

  default_action {
    type             = each.value
    target_group_arn = aws_lb_target_group.this.arn
  }
}

#  TODO: add listener_rule as optional resources, add link between created target groups and listener/rules

resource "aws_lb_listener" "this" {
  load_balancer_arn = var.lb_arn
  port              = var.port
  protocol          = var.port
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn
  alpn_policy       = var.alpn_policy

  dynamic "fixed_response" {
    for_each = var.fixed_response != null ? [var.fixed_response] : []
    content {
      content_type = fixed_response.value.content_type
      message_body = fixed_response.value.message_body
      region       = fixed_response.value.region
      status_code  = fixed_response.value.status_code
    }
  }

  dynamic "redirect" {
    for_each = var.redirect != null ? [var.redirect] : []
    content {
      status_code = redirect.value.status_code
      host        = redirect.value.host
      path        = redirect.value.path
      port        = redirect.value.port
      protocol    = redirect.value.protocol
      query       = redirect.value.query
      region      = redirect.value.region
    }
  }

  dynamic "mutual_authentication" {
    iterator = mtls
    for_each = var.mutual_authentication != null ? [var.mutual_authentication] : []
    content {
      mode            = mtls.value.mode
      trust_store_arn = mtls.value.trust_store_arn
    }
  }

  dynamic "default_action" {
    iterator = cognito
    for_each = var.cognito != null ? [var.cognito] : []
    content {
      type  = "authenticate-cognito"
      order = cognito.value.order
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
    iterator = oidc
    for_each = var.oidc != null ? [var.oidc] : []
    content {
      type  = "authenticate-oidc"
      order = oidc.value.order
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

  dynamic "default_action" {
    for_each = var.forward_tg != null ? [var.forward_tg] : []
    content {
      type             = "forward"
      target_group_arn = default_action.value.arn
      order            = default_action.value.order
    }
  }

  dynamic "default_action" {
    for_each = var.weighted_forward != null ? [var.weighted_forward] : []

    content {
      type  = "forward"
      order = action.value.order
      dynamic "target_group" {
        for_each = [default_action.value.target_groups]

        content {
          arn    = target_group.value.arn
          weight = target_group.value.weight
        }
      }

      dynamic "stickiness" {
        for_each = [default_action.value.stickiness]

        content {
          duration = stickiness.value.duration
          enabled  = stickiness.value.enabled
        }
      }
    }
  }
}


module "listener_rule" {
  source = "../listener_rules"

  for_each         = var.rules
  listener_arn     = aws_lb_listener.this.arn
  priority         = each.value.priority
  port             = each.value.port
  protocol         = each.value.protocol
  cognito          = each.value.cognito
  oidc             = each.value.oidc
  fixed_response   = each.value.fixed_response
  redirect         = each.value.redirect
  forward_tg       = each.value.forward_tg
  weighted_forward = each.value.weighted_forward
  conditions       = each.value.conditions

}
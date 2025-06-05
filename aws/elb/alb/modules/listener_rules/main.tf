resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority     = var.priority

  dynamic "action" {
    iterator = fixed_response
    for_each = var.fixed_response == null ? [] : [var.fixed_response]
    content {
      type  = "fixed-response"
      order = fixed_response.value.order
      fixed_response {
        content_type = fixed_response.value.content_type
        message_body = fixed_response.value.message_body
        status_code  = fixed_response.value.status_code
      }
    }
  }

  dynamic "action" {
    iterator = redirect
    for_each = var.redirect == null ? [] : [var.redirect]
    content {
      type  = "redirect"
      order = fixed_response.value.order
      redirect {
        status_code = redirect.value.status_code
        host        = redirect.value.host
        path        = redirect.value.path
        port        = redirect.value.port
        protocol    = redirect.value.protocol
        query       = redirect.value.query
      }
    }
  }

  dynamic "action" {
    iterator = cognito
    for_each = var.cognito == null ? [] : [var.cognito]
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

  dynamic "action" {
    iterator = oidc
    for_each = var.oidc == null ? [] : [var.oidc]
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

  dynamic "action" {
    for_each = var.forward_tg
    content {
      order            = action.value.order
      type             = "forward"
      target_group_arn = action.value.arn
    }
  }

  dynamic "action" {
    for_each = var.weighted_forward

    content {
      type  = "forward"
      order = action.value.order
      dynamic "target_group" {
        for_each = action.value.target_groups

        content {
          arn    = target_group.value.arn
          weight = target_group.value.weight
        }
      }

      dynamic "stickiness" {
        for_each = [action.value.stickiness]

        content {
          duration = stickiness.value.duration
          enabled  = stickiness.value.enabled
        }
      }
    }
  }

  dynamic "condition" {
    for_each = var.conditions == null ? [] : [var.conditions]
    content {
      dynamic "host_header" {
        for_each = condition.value.host_header == null ? [] : [condition.value.host_header]
        content {
          values = host_header.value
        }
      }

      dynamic "http_header" {
        for_each = condition.value.http_header == null ? [] : [condition.value.http_header]
        content {
          http_header_name = http_header.value.http_header_name
          values           = http_header.value.values
        }
      }

      dynamic "http_request_method" {
        for_each = condition.value.http_request_method == null ? [] : [condition.value.http_request_method]
        content {
          values = http_request_method.value
        }
      }

      dynamic "path_pattern" {
        for_each = condition.value.path_pattern == null ? [] : [condition.value.path_pattern]
        content {
          values = path_pattern.value
        }
      }

      dynamic "source_ip" {
        for_each = condition.value.source_ip == null ? [] : [condition.value.source_ip]
        content {
          values = source_ip.value
        }
      }

      dynamic "query_string" {
        for_each = condition.value.query_string == null ? [] : [condition.value.query_string]
        content {
          key   = query_string.value.key
          value = query_string.value.value
        }
      }
    }
  }
}
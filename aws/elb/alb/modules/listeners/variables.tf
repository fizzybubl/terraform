variable "lb_arn" {
  type    = string
  default = null
}

variable "port" {
  type    = string
  default = "80"
}

variable "protocol" {
  type    = string
  default = "HTTP"
}

variable "ssl_policy" {
  type    = string
  default = null
}

variable "alpn_policy" {
  type    = string
  default = null
}

variable "certificate_arn" {
  type    = string
  default = null
}

variable "mutual_authentication" {
  type = object({
    mode            = string
    trust_store_arn = string
  })
  default = null
}

variable "cognito" {
  type = object({
    order                               = optional(number)
    authentication_request_extra_params = optional(map(string))
    on_unauthenticated_request          = optional(string)
    scope                               = optional(string)
    session_cookie_name                 = optional(string)
    session_timeout                     = optional(number)
    user_pool_arn                       = string
    user_pool_client_id                 = string
    user_pool_domain                    = string
  })
  default = null
}

variable "oidc" {
  type = object({
    order                  = optional(number)
    authorization_endpoint = string
    client_id              = string
    client_secret          = string
    issuer                 = string
    token_endpoint         = string
    user_info_endpoint     = string
  })
  default = null
}


variable "fixed_response" {
  type = object({
    content_type = string
    message_body = optional(string)
    region       = optional(string)
    status_code  = optional(string)
    order        = optional(number)
  })
  default = null
}


variable "redirect" {
  type = object({
    host        = optional(string, "#{host}")
    path        = optional(string, "#{path}")
    port        = optional(string, "#{port}")
    protocol    = optional(string, "#{protocol}")
    query       = optional(string, "#{query}")
    region      = optional(string)
    order       = optional(number)
    status_code = string
  })
  default = null
}


variable "forward_tg" {
  type = list(object({
    arn   = string
    order = optional(number)
  }))
  default = []
}


variable "weighted_forward" {
  type = list(object({
    order = optional(number)
    target_groups = set(object({
      arn    = string
      weight = number
    }))
    stickiness = set(object({
      duration = optional(number, 60)
      enabled  = bool
    }))
  }))

  default = []
}


variable "rules" {
  type = map(object({
    priority     = number
    listener_arn = string
    port         = optional(string)
    protocol     = optional(string)

    cognito = optional(object({
      authentication_request_extra_params = optional(map(string))
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      user_pool_arn                       = string
      user_pool_client_id                 = string
      user_pool_domain                    = string
      order                               = optional(number)
    }))

    oidc = optional(object({
      authorization_endpoint = string
      client_id              = string
      client_secret          = string
      issuer                 = string
      token_endpoint         = string
      user_info_endpoint     = string
      order                  = optional(number)
    }))

    fixed_response = optional(object({
      content_type = string
      message_body = optional(string)
      region       = optional(string)
      status_code  = optional(string)
      order        = optional(number)
    }))

    redirect = optional(object({
      host        = optional(string, "#{host}")
      path        = optional(string, "#{path}")
      port        = optional(string, "#{port}")
      protocol    = optional(string, "#{protocol}")
      query       = optional(string, "#{query}")
      region      = optional(string)
      order       = optional(number)
      status_code = string
    }))

    forward_tg = optional(object({
      arn   = string
      order = optional(number)
    }))

    weighted_forward = optional(object({
      target_groups = set(object({
        arn    = string
        weight = number
      }))
      stickiness = set(object({
        duration = optional(number, 60)
        enabled  = bool
      }))
      order = optional(number)
    }))

    conditions = optional(set(object({
      host_header = optional(list(string))
      http_header = optional(object({
        http_header_name = string
        values           = optional(list(string))
      }))
      query_string = optional(object({
        key   = string
        value = string
      }))
      http_request_method = optional(list(string))
      path_pattern        = optional(list(string))
      source_ip           = optional(list(string))
    })))
  }))
  default = {}
}
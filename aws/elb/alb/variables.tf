variable "region" {
  type    = string
  default = "eu-central-1"
}


variable "name" {
  type = string
}


variable "internal" {
  type    = bool
  default = false
}


variable "lb_type" {
  type    = string
  default = "application"
}


variable "security_group_ids" {
  type    = set(string)
  default = []
}


variable "subnet_ids" {
  type    = set(string)
  default = []
}


variable "lb_tags" {
  type    = map(string)
  default = {}
}

variable "deletion_protection" {
  type    = bool
  default = false
}


variable "target_groups" {
  type = map(object({
    name                 = string
    vpc_id               = string
    type                 = optional(string, "instance")
    port                 = optional(string, 80)
    protocol             = optional(string, "HTTP")
    deregistration_delay = optional(number, 300)
    target_id            = optional(string)
    asg_name             = optional(string)
    listener             = string
    weight               = optional(number)
    health_check = object({
      enabled           = optional(bool, true)
      healthy_threshold = optional(number, 3)
      interval          = optional(number, 60)
      matcher           = optional(number, 200)
      path              = optional(string, "/")
      port              = optional(string, "traffic-port")
      protocol          = optional(string, null) # TCP, HTTP, or HTTPS, null for lambda
      timeout           = optional(number, 30)
    })
    stickiness = object({
      cookie_duration = optional(number, 86400)
      type            = optional(string, "lb_cookie")
      cookie_name     = optional(string, null)
      enabled         = optional(bool, true)
    })
  }))
}


variable "listeners" {
  type = map(object({
    lb_arn          = optional(string)
    port            = optional(string, "80")
    protocol        = optional(string, "HTTP")
    ssl_policy      = optional(string)
    alpn_policy     = optional(string)
    certificate_arn = optional(string)
    mutual_authentication = optional(object({
      mode            = string
      trust_store_arn = string
    }))

    cognito = optional(object({
      authentication_request_extra_params = optional(map(string))
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      user_pool_arn                       = string
      user_pool_client_id                 = string
      user_pool_domain                    = string
    }))

    oidc = optional(object({
      authorization_endpoint = string
      client_id              = string
      client_secret          = string
      issuer                 = string
      token_endpoint         = string
      user_info_endpoint     = string
    }))


    forward_tg = optional(list(object({
        arn   = string
        order = optional(number)
      })
    ), [])

    weighted_forward = optional(list(object({
      target_groups = set(object({
        arn    = string
        weight = optional(number, 1)
      }))
      stickiness = set(object({
        duration = optional(number, 60)
        enabled  = bool
      }))
      })
    ), [])
  }))
}
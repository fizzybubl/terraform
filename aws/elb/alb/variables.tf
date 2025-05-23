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
  default = true
}


variable "target_groups" {
  type = map(object({
    name                 = string
    vpc_id               = string
    type                 = optional(string, "instance")
    port                 = optional(string, 80)
    protocol             = optional(string, "HTTP")
    deregistration_delay = optional(number, 300)
    healthcheck = object({
      enabled           = optional(bool, true)
      healthy_threshold = optional(number, 3)
      interval          = optional(number, 30)
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

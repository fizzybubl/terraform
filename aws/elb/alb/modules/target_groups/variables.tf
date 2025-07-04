variable "name" {
  type    = string
  default = null
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "type" {
  type    = string
  default = "instance"
}

variable "port" {
  type    = string
  default = "80"
}

variable "protocol" {
  type    = string
  default = "HTTP"
}

variable "deregistration_delay" {
  type    = number
  default = 300
}

variable "health_check" {
  type = object({
    enabled           = optional(bool, true)
    healthy_threshold = optional(number, 3)
    interval          = optional(number, 30)
    matcher           = optional(string, "200")
    path              = optional(string, "/")
    port              = optional(string, "traffic-port")
    protocol          = optional(string, null) # TCP, HTTP, HTTPS, or null for lambda
    timeout           = optional(number, 30)
  })
  default = null
}

variable "stickiness" {
  type = object({
    cookie_duration = optional(number, 86400)
    type            = optional(string, "lb_cookie")
    cookie_name     = optional(string, null)
    enabled         = optional(bool, true)
  })
  default = null
}


variable "asg_name" {
  type    = string
  default = null
}


variable "target_id" {
  type    = string
  default = null
}
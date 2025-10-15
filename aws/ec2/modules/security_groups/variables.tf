variable "ingress_rules" {
  description = "Map of named ingress rule objects"
  type = map(object({
    self            = optional(bool, false)
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_block      = optional(string)
    ipv6_cidr_block = optional(string)
    security_group  = optional(string)
    prefix_list_id  = optional(string)
  }))
  default = null

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules != null ? var.ingress_rules : {}) : (
        (
          (rule.cidr_block != null ? 1 : 0) +
          (rule.ipv6_cidr_block != null ? 1 : 0) +
          (rule.security_group != null ? 1 : 0) +
          (rule.prefix_list_id != null ? 1 : 0) + (rule.self ? 1 : 0)
        ) == 1
      )
    ])
    error_message = "Each ingress rule must have exactly one of cidr_block, ipv6_cidr_block, security_group, self or prefix_list_id set."
  }
}

variable "egress_rules" {
  description = "Map of named egress rule objects"
  type = map(object({
    self            = optional(bool, false)
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_block      = optional(string)
    ipv6_cidr_block = optional(string)
    security_group  = optional(string)
    prefix_list_id  = optional(string)
  }))
  default = null

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules != null ? var.egress_rules : {}) : (
        (
          (rule.cidr_block != null ? 1 : 0) +
          (rule.ipv6_cidr_block != null ? 1 : 0) +
          (rule.security_group != null ? 1 : 0) +
          (rule.prefix_list_id != null ? 1 : 0)
        ) == 1
      )
    ])
    error_message = "Each egress rule must have exactly one of cidr_block, ipv6_cidr_block, security_group, or prefix_list_id set."
  }
}


variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}

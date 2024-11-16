variable "security_group" {
  type = object({
    name   = string,
    vpc_id = string
    tags   = optional(map(string), null)
  })
}

variable "ingress" {
  type = map(object({
    protocol       = string
    from_port      = number
    to_port        = number
    src_sg         = optional(string, null)
    cidr_ipv4      = optional(string, null)
    prefix_list_id = optional(string, null)
  }))
}


variable "egress" {
  type = map(object({
    protocol       = string
    from_port      = number
    to_port        = number
    dest_sg        = optional(string, null)
    cidr_ipv4      = optional(string, null)
    prefix_list_id = optional(string, null)
  }))
}
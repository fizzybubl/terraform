variable "security_groups" {
  type = object({
    name = string,
    ingress = object({
      name = string
      protocol = string
      from_port = number
      to_port = number
      src_sg = optional(string)
      cidr_block = optional(string)
    })
    egress = object({
      name = string
      protocol = string
      from_port = number
      to_port = number
      dest_sg = optional(string)
      cidr_block = optional(string)
    })
    vpc_id = string
    tags = optional(map(string, string))
  })
}
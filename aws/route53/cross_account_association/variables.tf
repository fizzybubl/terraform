variable "vpc_association" {
  description = "Association data indicating zone_id and vpc_id to associate."
  type = object({
    zone_id    = string
    vpc_id     = string
    vpc_region = optional(string)
  })
}
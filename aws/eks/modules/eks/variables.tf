variable "cluster_name" {
  type = string
}


variable "subnet_ids" {
  type = list(string)
}


variable "authentication_mode" {
  type    = string
  default = "API"
}


variable "version" {
  type    = string
  default = "1.32"
}


variable "bootstrap_self_managed_addons" {
  type    = bool
  default = false
}


variable "enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator"]
}


variable "bootstrap_cluster_creator_admin_permissions" {
  type    = bool
  default = true
}


variable "key_arn" {
  type    = string
  default = null
}


variable "endpoint_public_access" {
  type    = bool
  default = true
}


variable "public_access_cidrs" {
  type    = list(string)
  default = null
}


variable "security_group_ids" {
  type = list(string)
}


variable "kubernetes_network_config" {
  type = object({
    elastic_load_balancing = optiona(bool)
    ip_family              = optional(string)
    service_ipv4_cidr      = optional(string, "172.20.0.0/16")
  })
}


variable "support_type" {
  type = string
  default = "STANDARD"
}
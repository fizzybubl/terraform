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


variable "eks_version" {
  type    = string
  default = "1.32"
}


variable "bootstrap_self_managed_addons" {
  type    = bool
  default = true
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


variable "node_security_group_ids" {
  type = list(string)
}


variable "kubernetes_network_config" {
  type = object({
    elastic_load_balancing = optional(bool)
    ip_family              = optional(string)
    service_ipv4_cidr      = optional(string, "172.20.0.0/16")
  })
  default = {}
}


variable "support_type" {
  type    = string
  default = "STANDARD"
}


variable "access_entries" {
  type = map(object({
    principal_arn     = string
    kubernetes_groups = optional(list(string))
    type              = optional(string, "STANDARD")
    user_name         = optional(string)
  }))
  default = {}
}


variable "access_entries_policies" {
  type = map(object({
    principal_arn = string
    policy_arn    = string
    access_scope = optional(object({
      type       = string
      namespaces = optional(list(string), [])
    }))
  }))
  default = {}
}


variable "addons" {
  type = map(object({
    version              = string
    configuration_values = optional(map(string))
    policy_arn           = optional(string)
    pod_identity_association = optional(object({
      role_arn        = string
      service_account = string
    }))
  }))
  default = {}
}


variable "pod_identities" {
  type = map(object({
    service_account = string
    namespace       = string
    role_arn        = string
  }))
  default = {}
}


variable "node_groups_config" {
  type = map(object({
    name                       = optional(string)
    name_prefix                = optional(string)
    role_arn                   = optional(string)
    subnet_ids                 = list(string)
    capacity_type              = optional(string, "ON_DEMAND")
    instance_types             = list(string)
    labels                     = optional(map(string))
    min_size                   = optional(number, 1)
    max_size                   = optional(number, 1)
    desired_size               = optional(number, 1)
    max_unavailable            = optional(number, 1)
    max_unavailable_percentage = optional(number)
    disk_size                  = optional(number)
    volume_size                = optional(number, 20)
    volume_type                = optional(string, "gp3")
  }))
  default = {}
}


variable "user_data" {
  type    = string
  default = null
}


variable "default_worker_role" {
  type    = bool
  default = true
}

variable "create_launch_template" {
  type    = bool
  default = true
}

variable "image_id" {
  type = string
}

variable "cluster_autoscaler_values" {
  type    = string
  default = null
}

variable "region" {
  type = string
}


variable "profile" {
  type = string
}
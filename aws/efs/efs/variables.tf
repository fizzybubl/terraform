variable "name" {
  type    = string
  default = "efs"
}


variable "tags" {
  type    = map(string)
  default = {}
}


variable "encrypted" {
  type    = bool
  default = false
}


variable "kms_key_id" {
  type    = string
  default = null
}


variable "performance_mode" {
  type    = string
  default = "generalPurpose"
}


variable "throughput_mode" {
  type    = string
  default = "bursting"
}


variable "provisioned_throughput_in_mibps" {
  type    = string
  default = null
}


variable "replication_overwrite" {
  type    = string
  default = "ENABLED"
}

variable "subnet_ids" {
  type = map(object({
    subnet_id       = string
    security_groups = set(string)
  }))
}

variable "backup_status" {
  type    = string
  default = "ENABLED"
}


variable "access_point" {
  type = object({
    tags        = optional(map(string), { "Name" : "EFS Access Point" })
    permissions = optional(string, "0777")
    uid         = optional(string, "1000")
    gid         = optional(string, "1000")
    owner_gid   = optional(string, "1000")
    owner_uid   = optional(string, "1000")
    path        = optional(string, "/")

  })
  default = null
}
variable "asg_name" {
  type = string
  default = "default-asg-name"
}

variable "instance" {
  type    = bool
  default = false
}

variable "template_name" {
  type        = string
  default     = "template"
  description = "name for launch template"
}

variable "key_name" {
  type        = string
  default     = "key_name"
  description = "name for launch template key"
}

variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "security_group_ids" {
  type    = list(string)
  default = null
}

variable "subnet_ids" {
  type    = list(string)
  default = null
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "health_check_type" {
  type    = string
  default = "EC2"
}

variable "health_check_grace_period" {
  type    = number
  default = 300
}

variable "termination_policies" {
  type    = list(string)
  default = ["OldestLaunchTemplate"]
}

variable "enabled_metrics" {
  type    = list(string)
  default = []
}

variable "metrics_granularity" {
  type    = string
  default = "1Minute"
}

variable "capacity_rebalance" {
  type    = bool
  default = false
}

variable "default_instance_warmup" {
  type    = number
  default = null
}

variable "wait_for_capacity_timeout" {
  type    = string
  default = "10m"
}

variable "wait_for_elb_capacity" {
  type    = number
  default = null
}

variable "force_delete" {
  type    = bool
  default = false
}

variable "max_instance_lifetime" {
  type    = number
  default = null
}

variable "protect_from_scale_in" {
  type    = bool
  default = false
}

variable "update_default_version" {
  type    = bool
  default = true
}

variable "disable_api_termination" {
  type    = bool
  default = false
}

variable "disable_api_stop" {
  type    = bool
  default = false
}

variable "ebs_optimized" {
  type    = bool
  default = false
}

variable "instance_initiated_shutdown_behavior" {
  type    = string
  default = "stop"
}

variable "iam_instance_profile_name" {
  type    = string
  default = null
}

variable "block_device_mappings" {
  type = list(object({
    device_name  = string
    no_device    = optional(string)
    virtual_name = optional(string)
    ebs = optional(object({
      delete_on_termination = optional(bool)
      encrypted             = optional(bool)
      iops                  = optional(number)
      throughput            = optional(number)
      volume_size           = optional(number)
      volume_type           = optional(string)
      kms_key_id            = optional(string)
      snapshot_id           = optional(string)
    }))
  }))
  default = []
}

variable "enable_hibernation" {
  type    = bool
  default = false
}

variable "enable_monitoring" {
  type    = bool
  default = false
}

variable "instance_requirements" {
  type = object({
    baseline_ebs_bandwidth_mbps = object({
      min = optional(number)
      max = optional(number)
    })
    memory_mib = object({
      min = optional(number, 0.5)
      max = optional(number)
    })
    vcpu_count = object({
      min = optional(number, 0.5)
      max = optional(number)
    })
    network_bandwidth_gbps = object({
      min = optional(number)
      max = optional(number)
    })
    network_interface_count = object({
      min = optional(number)
      max = optional(number)
    })
    total_local_storage_gb = object({
      min = optional(number)
      max = optional(number)
    })
    allowed_instance_types                                  = optional(list(string))
    excluded_instance_types                                 = optional(list(string))
    instance_generations                                    = optional(list(string))
    local_storage                                           = optional(string, "included")
    local_storage_types                                     = optional(list(string))
    max_spot_price_as_percentage_of_optimal_on_demand_price = optional(number, 40)
    on_demand_max_price_percentage_over_lowest_price        = optional(number, 20)
    spot_max_price_percentage_over_lowest_price             = optional(number)
    require_hibernate_support                               = optional(bool, false)
  })

  default = null
}

variable "instance_market_options" {
  type = object({
    market_type = string
    spot_options = object({
      block_duration_minutes         = optional(number, 60)
      instance_interruption_behavior = optional(string, "terminate")
      max_price                      = string
      spot_instance_type             = optional(string, "one-time")
      valid_until                    = string
    })
  })

  default = null
}

variable "metadata_http_endpoint" {
  type    = string
  default = "enabled"
}

variable "metadata_http_tokens" {
  type    = string
  default = "optional"
}

variable "metadata_http_put_response_hop_limit" {
  type    = number
  default = 1
}

variable "metadata_tags" {
  type    = string
  default = "disabled"
}

variable "user_data_base64" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "kernel_id" {
  type    = string
  default = null
}

variable "ram_disk_id" {
  type    = string
  default = null
}

variable "network_interfaces" {
  type = list(object({
    device_index                = optional(number)
    interface_type              = optional(string, "interface")
    delete_on_termination       = optional(bool, true)
    associate_public_ip_address = optional(bool, false)
    network_interface_id        = optional(string)
    network_card_index          = optional(number)
    private_ip_address          = optional(string)
    subnet_id                   = optional(string)
    security_group_ids          = optional(list(string))
    ipv4_addresses              = optional(set(string))
    ipv4_address_count          = optional(number)
  }))

  default = null
}

variable "partition" {
  type = object({
    name            = string
    partition_count = optional(number)
    spread_level    = optional(string)
    strategy        = string
    tags            = optional(map(string), {})
  })

  default = {
    name = "default_partition"
    partition_count = null
    strategy = "spread"
    spread_level = "host"
    tags = {}
  }
}
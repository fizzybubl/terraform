resource "aws_launch_template" "this" {
  name_prefix   = "${var.template_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  disable_api_termination              = var.disable_api_termination
  disable_api_stop                     = var.disable_api_stop
  ebs_optimized                        = var.ebs_optimized
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  kernel_id                            = var.kernel_id
  ram_disk_id                          = var.ram_disk_id
  user_data                            = var.user_data_base64

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = block_device_mappings.value.device_name
      no_device    = block_device_mappings.value.no_device
      virtual_name = block_device_mappings.value.virtual_name

      ebs {
        delete_on_termination = block_device_mappings.value.ebs.delete_on_termination
        encrypted             = block_device_mappings.value.ebs.encrypted
        iops                  = block_device_mappings.value.ebs.iops
        throughput            = block_device_mappings.value.ebs.throughput
        volume_size           = block_device_mappings.value.ebs.volume_size
        volume_type           = block_device_mappings.value.ebs.volume_type
        kms_key_id            = block_device_mappings.value.ebs.kms_key_id
        snapshot_id           = block_device_mappings.value.ebs.snapshot_id
      }
    }
  }

  hibernation_options {
    configured = var.enable_hibernation
  }

  instance_requirements {
    allowed_instance_types                                  = var.instance_requirements.allowed_instance_types
    excluded_instance_types                                 = var.instance_requirements.excluded_instance_types
    instance_generations                                    = var.instance_requirements.instance_generations
    local_storage                                           = var.instance_requirements.local_storage
    local_storage_types                                     = var.instance_requirements.local_storage_types
    max_spot_price_as_percentage_of_optimal_on_demand_price = var.instance_requirements.max_spot_price_as_percentage_of_optimal_on_demand_price
    on_demand_max_price_percentage_over_lowest_price        = var.instance_requirements.on_demand_max_price_percentage_over_lowest_price
    spot_max_price_percentage_over_lowest_price             = var.instance_requirements.spot_max_price_percentage_over_lowest_price
    require_hibernate_support                               = var.instance_requirements.require_hibernate_support

    baseline_ebs_bandwidth_mbps {
      min = var.instance_requirements.baseline_ebs_bandwidth_mbps.min
      max = var.instance_requirements.baseline_ebs_bandwidth_mbps.max
    }

    memory_mib {
      min = var.instance_requirements.memory_mib.min
      max = var.instance_requirements.memory_mib.max
    }

    network_bandwidth_gbps {
      min = var.instance_requirements.network_bandwidth_gbps.min
      max = var.instance_requirements.network_bandwidth_gbps.max
    }

    network_interface_count {
      min = var.instance_requirements.network_interface_count.min
      max = var.instance_requirements.network_interface_count.max
    }

    total_local_storage_gb {
      min = var.instance_requirements.total_local_storage_gb.min
      max = var.instance_requirements.total_local_storage_gb.max
    }

    vcpu_count {
      min = var.instance_requirements.vcpu_count.min
      max = var.instance_requirements.vcpu_count.max
    }
  }

  instance_market_options {
    market_type = var.instance_market_options.market_type

    spot_options {
      block_duration_minutes         = var.instance_market_options.spot_options.block_duration_minutes
      instance_interruption_behavior = var.instance_market_options.spot_options.instance_interruption_behavior
      max_price                      = var.instance_market_options.spot_options.max_price
      spot_instance_type             = var.instance_market_options.spot_options.spot_instance_type
      valid_until                    = var.instance_market_options.spot_options.valid_until
    }
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    instance_metadata_tags      = var.metadata_tags
  }

  dynamic "network_interfaces" {
    iterator = "nic"
    for_each = var.network_interfaces
    content {
      device_index                = nic.value.device_index
      interface_type              = nic.value.interface_type
      delete_on_termination       = nic.value.delete_on_termination
      associate_public_ip_address = nic.value.associate_public_ip_address
      network_interface_id        = nic.value.network_interface_id
      network_card_index          = nic.value.network_card_index
      private_ip_address          = nic.value.private_ip_address
      subnet_id                   = nic.value.subnet_id
      security_groups             = nic.value.security_group_ids
      ipv4_addresses              = nic.value.ipv4_addresses
      ipv4_address_count          = nic.value.ipv4_address_count
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      { Name = "${var.template_name}-instance" }
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix             = "asg-"
  desired_capacity        = var.desired_capacity
  min_size                = var.min_size
  max_size                = var.max_size
  vpc_zone_identifier     = var.subnet_ids
  capacity_rebalance      = var.capacity_rebalance
  default_instance_warmup = var.default_instance_warmup

  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  force_delete              = var.force_delete
  termination_policies      = var.termination_policies
  max_instance_lifetime     = var.max_instance_lifetime
  protect_from_scale_in     = var.protect_from_scale_in

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns   = var.target_group_arns
  load_balancers      = var.load_balancers
  enabled_metrics     = var.enabled_metrics
  metrics_granularity = var.metrics_granularity

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "this" {
  count = var.instance ? 1 : 0
  launch_template {
    version = aws_launch_template.this.latest_version
    id = aws_launch_template.this.id
  }
}


resource "aws_placement_group" "this" {
  for_each = var.partition == null ? {} : {"partition" => var.partition}
  name     = var.name
  strategy = var.partition.strategy
  spread_level = var.partition.spread_level
  partition_count = var.partition.partition_count
  tags = var.partition.tags
}

resource "aws_autoscaling_group" "bar" {
  name                      = var.name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  placement_group           = aws_placement_group.this.id
  launch_template           = aws_launch_configuration.this.name
  vpc_zone_identifier       = var.subnet_ids

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_lifecycle_hook" "foobar" {
  name                   = "foobar"
  autoscaling_group_name = aws_autoscaling_group.foobar.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 2000
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

  notification_metadata = jsonencode({
    foo = "bar"
  })

  notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
  role_arn                = "arn:aws:iam::123456789012:role/S3Access"
}
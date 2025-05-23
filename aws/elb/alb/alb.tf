resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = var.lb_type
  internal           = var.internal
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.deletion_protection

  tags = var.lb_tags
}


resource "aws_lb_target_group" "this" {
  for_each             = var.target_groups
  name                 = each.value.name
  target_type          = each.value.type
  port                 = each.value.port
  protocol             = each.value.protocol
  vpc_id               = each.value.vpc_id
  deregistration_delay = each.value.deregistration_delay

  health_check {
    healthy_threshold = each.value.health_check.healthy_threshold
    enabled           = each.value.health_check.enable
    interval          = each.value.health_check.interval
    matcher           = each.value.health_check.matcher
    path              = each.value.health_check.path
    port              = each.value.health_check.port
    protocol          = each.value.health_check.protocol
    timeout           = each.value.health_check.timeout
  }

  stickiness {
    type            = each.value.stickiness.type
    cookie_duration = each.value.stickiness.cookie_duration
    cookie_name     = each.value.stickiness.cookie_name
    enabled         = each.value.stickiness.enabled
  }
}


resource "aws_autoscaling_attachment" "this" {
  for_each               = var.target_groups
  lb_target_group_arn    = aws_lb_target_group.this[each.key].arn
  autoscaling_group_name = each.value.asg_name
}

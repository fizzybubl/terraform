
resource "aws_lb_target_group" "this" {
  name                 = var.name
  target_type          = var.type
  port                 = var.port
  protocol             = var.protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay

  health_check {
    healthy_threshold = var.health_check.healthy_threshold
    enabled           = var.health_check.enable
    interval          = var.health_check.interval
    matcher           = var.health_check.matcher
    path              = var.health_check.path
    port              = var.health_check.port
    protocol          = var.health_check.protocol
    timeout           = var.health_check.timeout
  }

  stickiness {
    type            = var.stickiness.type
    cookie_duration = var.stickiness.cookie_duration
    cookie_name     = var.stickiness.cookie_name
    enabled         = var.stickiness.enabled
  }
}
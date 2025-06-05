
resource "aws_lb_target_group" "this" {
  name                 = var.name
  target_type          = var.type
  port                 = var.port
  protocol             = var.protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay

  health_check {
    healthy_threshold = var.health_check.healthy_threshold
    enabled           = var.health_check.enabled
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


resource "aws_autoscaling_attachment" "this" {
  count                  = var.asg_name == null ? 0 : 1
  lb_target_group_arn    = aws_lb_target_group.this.arn
  autoscaling_group_name = var.asg_name
}


resource "aws_lb_target_group_attachment" "this" {
  count            = var.target_id == null ? 0 : 1
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_id
}
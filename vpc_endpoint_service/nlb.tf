resource "aws_lb" "ep_service" {
  name               = "NLB-Endpoint-Service"
  internal           = true
  load_balancer_type = "network"
  subnets            = [for subnet in module.vpc["service"].private_subnets : subnet.id]

  tags = {
    Name = "NLB Endpoint Service"
  }
}


resource "aws_lb_target_group" "nlb_tg" {
  target_type = "alb"
  protocol    = "TCP"
  port        = 80
  vpc_id      = module.vpc["service"].vpc.id
}


resource "aws_lb_target_group_attachment" "to_alb" {
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = aws_lb.internal_alb.arn
  depends_on       = [aws_lb.internal_alb, aws_lb_listener.alb_default]
}


resource "aws_lb_listener" "nlb_default" {
  load_balancer_arn = aws_lb.ep_service.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}


# ALB SETUP
resource "aws_lb" "internal_alb" {
  name            = "ALB-Endpoint-Service"
  internal        = true
  subnets         = [for subnet in module.vpc["service"].private_subnets : subnet.id]
  security_groups = [module.security_group["alb"].security_group.id]

  tags = {
    Name = "ALB Endpoint Service"
  }
}


resource "aws_lb_listener" "alb_default" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}
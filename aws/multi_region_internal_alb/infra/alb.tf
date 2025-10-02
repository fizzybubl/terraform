resource "aws_lb" "fra" {
  name               = "fra-internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.fra.id]
  subnets            = [for key, subnet in aws_subnet.private_fra : subnet.id]
  tags = {
    Name = "ALB_FRA"
  }
}



resource "aws_lb_listener" "fra" {
  load_balancer_arn = aws_lb.fra.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = jsonencode({
        message = "eu-central-1"
      })
      status_code = "200"
    }
  }
}


resource "aws_lb" "dub" {
  provider           = aws.dub
  name               = "dub-internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dub.id]
  subnets            = [for key, subnet in aws_subnet.private_dub : subnet.id]

  tags = {
    Name = "ALB_DUB"
  }
}

resource "aws_lb_listener" "dub" {
  provider          = aws.dub
  load_balancer_arn = aws_lb.dub.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = jsonencode({
        message = "eu-west-1"
      })
      status_code = "200"
    }
  }
}

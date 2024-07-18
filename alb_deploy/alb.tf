data "aws_ami" "image" {
  filter {
    name = "image-id"
    values = ["ami-0346fd83e3383dcb4"]
    # values = ["ami-0e872aee57663ae2d"]
  }
}


resource "aws_lb" "alb" {
  name               = "ApplicationLoadBalancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = toset(data.aws_subnets.default_subnets.ids)
  security_groups    = toset([aws_security_group.alb_sg.id])
}

resource "aws_placement_group" "test" {
  name     = "test"
  strategy = "spread"
}


resource "aws_launch_template" "launch_template" {
  name_prefix            = "foobar"
  image_id               = data.aws_ami.image.id
  instance_type          = tolist(var.instance_types)[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  depends_on = [aws_security_group.ec2_sg]

  lifecycle {
    ignore_changes = [  ]
  }
}


resource "aws_autoscaling_group" "ec2_asg" {
  name                      = "auto_scaling_group"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  placement_group           = aws_placement_group.test.id
  vpc_zone_identifier       = toset(data.aws_subnets.default_subnets.ids)

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.launch_template.id
        version            = aws_launch_template.launch_template.latest_version
      }

      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
  }

  instance_refresh {
    strategy = "Rolling"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name        = "TerraformPractice"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id

  health_check {
    enabled  = true
    protocol = "HTTP"
    port     = "80"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.id
  lb_target_group_arn    = aws_lb_target_group.lb_target_group.arn
}
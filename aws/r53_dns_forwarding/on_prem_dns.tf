data "aws_ami" "ami" {

  filter {
    name   = "image-id"
    values = ["ami-0559679b06ebd7e58"]
  }

}


data "cloudinit_config" "user_data" {
  gzip = false
  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/files/user_data.tpl.sh", {
      APP_PRIVATE_IP="10.10.0.10 ",
      FORWARDED_IP="10.10.0.2"
    })
  }
}


resource "aws_launch_template" "on_prem_dns" {
  name_prefix = "eks_worker_template"
  image_id    = data.aws_ami.ami.id

  instance_type = "t2.micro"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }

  user_data = data.cloudinit_config.user_data.rendered
}


resource "aws_placement_group" "test" {
  name     = "test"
  strategy = "spread"
}


resource "aws_autoscaling_group" "ec2_asg" {
  name                      = "auto_scaling_group"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  placement_group           = aws_placement_group.test.id
  vpc_zone_identifier = [ module.on_prem_subnet_1.subnet_id, module.on_prem_subnet_2.subnet_id ]

  launch_template {
    id      = aws_launch_template.on_prem_dns.id
    version = "$Latest"
  }
}
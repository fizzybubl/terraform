data "aws_ami" "ami" {

  filter {
    name   = "image-id"
    values = ["ami-00a18294952882aa9"]
  }

}



data "cloudinit_config" "user_data" {
  gzip = false
  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/files/user_data.sh")
  }
}


# Cluster security group
resource "aws_security_group" "ec2" {
  name   = "ClusterSecurityGroup"
  vpc_id = module.cloud_vpc.vpc_id

  tags = {
    "Name" = "AllowAll"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_inbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.cloud_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "internet_inbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_vpc_security_group_egress_rule" "vpc_outbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.cloud_vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "internet_outbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_launch_template" "ec2" {
  name_prefix = "eks_worker_template"
  image_id    = data.aws_ami.ami.id

  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  instance_type = "t2.micro"

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
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  placement_group           = aws_placement_group.test.id
  vpc_zone_identifier       = concat([module.cloud_web_rtb.subnet_id], [for az_id in local.az_ids : module.cloud_web[az_id].subnet_id if az_id != local.az_ids[0]])

  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"
  }
}
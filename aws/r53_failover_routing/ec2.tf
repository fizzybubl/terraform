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
    content      = file("${path.module}/files/user_data.sh")
  }
}


# Cluster security group
resource "aws_security_group" "ec2" {
  name   = "GeneralSG"
  vpc_id = data.aws_vpc.default.id

  tags = {
    "Name" = "AllowAll"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_inbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = data.aws_vpc.default.cidr_block
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
  cidr_ipv4         = data.aws_vpc.default.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "internet_outbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_eip" "public_ip" {
  domain               = "vpc"
  network_border_group = var.region
}


resource "aws_network_interface" "public_ip" {
  subnet_id = data.aws_subnets.default.ids[0]
}


resource "aws_eip_association" "public_ip" {
  network_interface_id = aws_network_interface.public_ip.id
  allocation_id        = aws_eip.public_ip.id
}


resource "aws_launch_template" "ec2" {
  name_prefix = "eks_worker_template"
  image_id    = data.aws_ami.ami.id

  vpc_security_group_ids = [aws_security_group.ec2.id]

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

  network_interfaces {
    network_interface_id = aws_network_interface.public_ip.id
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
  vpc_zone_identifier       = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"
  }
}
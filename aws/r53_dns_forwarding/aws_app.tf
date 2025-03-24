resource "aws_network_interface" "aws_ec2" {
  subnet_id = module.aws_subnet_1.subnet_id
  private_ip = "10.0.0.10"
  security_groups = [aws_security_group.on_prem_ec2.id]
}


resource "aws_launch_template" "aws_ec2" {
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

  network_interfaces {
    network_card_index = 0
    network_interface_id = aws_network_interface.aws_ec2.id
  }
}

resource "aws_instance" "aws_ec2" {
  launch_template {
    id = aws_launch_template.aws_ec2.id
    version = "$Latest"
  }
}
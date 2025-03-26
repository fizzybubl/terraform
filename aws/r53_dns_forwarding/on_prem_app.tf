resource "aws_network_interface" "on_prem_ec2" {
  subnet_id       = module.on_prem_subnet_1.subnet_id
  private_ip      = "10.10.0.10"
  security_groups = [aws_security_group.on_prem_ec2.id]
}



data "cloudinit_config" "user_data_app" {
  gzip = false
  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/user_data_on_prem_app.tpl.sh", {
      DNS_IP_1 = aws_network_interface.on_prem_dns1.private_ip,
      DNS_IP_2 = aws_network_interface.on_prem_dns2.private_ip
    })
  }

  depends_on = [aws_route53_resolver_endpoint.inbound]
}


resource "aws_launch_template" "on_prem_ec2" {
  name_prefix = "eks_worker_template"
  image_id    = data.aws_ami.ami.id

  instance_type = "t2.micro"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  user_data = data.cloudinit_config.user_data_app.rendered

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }

  network_interfaces {
    network_card_index   = 0
    network_interface_id = aws_network_interface.on_prem_ec2.id
  }
}

resource "aws_instance" "on_prem_ec2" {
  launch_template {
    id      = aws_launch_template.on_prem_ec2.id
    version = "$Latest"
  }
}
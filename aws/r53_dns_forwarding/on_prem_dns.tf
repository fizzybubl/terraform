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
    content = templatefile("${path.module}/files/user_data_dns.tpl.sh", {
      APP_PRIVATE_IP = "10.10.0.10",
      FORWARDER_IP   = "10.10.0.2",
      INBOUND_IP1    = local.inbound_ip1,
      INBOUND_IP2    = local.inbound_ip2,
      DNS_IP_1       = aws_network_interface.on_prem_dns1.private_ip,
      DNS_IP_2       = aws_network_interface.on_prem_dns2.private_ip
    })
  }
}


resource "aws_network_interface" "on_prem_dns1" {
  subnet_id       = module.on_prem_subnet_1.subnet_id
  private_ips     = ["10.10.1.100"]
  security_groups = [aws_security_group.on_prem_ec2.id]
}


resource "aws_network_interface" "on_prem_dns2" {
  subnet_id       = module.on_prem_subnet_2.subnet_id
  private_ips     = ["10.10.2.101"]
  security_groups = [aws_security_group.on_prem_ec2.id]
}


resource "aws_instance" "on_prem_dns1" {
  instance_type = "t2.micro"

  ami = data.aws_ami.ami.id

  user_data = data.cloudinit_config.user_data.rendered

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.on_prem_dns1.id
  }

  tags = {
    Name = "On Prem DNS1"
  }

  depends_on = [ aws_nat_gateway.this ]
}


resource "aws_instance" "on_prem_dns2" {
  instance_type = "t2.micro"

  ami = data.aws_ami.ami.id

  user_data = data.cloudinit_config.user_data.rendered

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.on_prem_dns2.id
  }

  tags = {
    Name = "On Prem DNS2"
  }

  depends_on = [ aws_nat_gateway.this ]
}
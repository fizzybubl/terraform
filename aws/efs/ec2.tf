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

    })
  }
}


resource "aws_instance" "producer" {
  instance_type = "t2.micro"

  ami = data.aws_ami.ami.id

  user_data       = data.cloudinit_config.user_data.rendered
  subnet_id       = module.aws_subnet_1.subnet_id
  security_groups = [aws_security_group.aws_ec2.id]

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

  tags = {
    Name = "Producer"
  }
}
resource "aws_instance" "consumer" {
  instance_type = "t2.micro"

  ami = data.aws_ami.ami.id

  user_data = data.cloudinit_config.user_data.rendered

  subnet_id       = module.aws_subnet_2.subnet_id
  security_groups = [aws_security_group.aws_ec2.id]

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

  tags = {
    Name = "Consumer"
  }
}
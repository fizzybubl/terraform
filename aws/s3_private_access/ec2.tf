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
  vpc_id = module.private_vpc.vpc_id

  tags = {
    "Name" = "AllowAll"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_inbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         =  module.private_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "ec2_instance_connect_inbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  referenced_security_group_id = aws_security_group.instance_connect.id
}


resource "aws_vpc_security_group_egress_rule" "vpc_outbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         =  module.private_vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "internet_outbound_access" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  prefix_list_id = aws_vpc_endpoint.private_s3.prefix_list_id
}


resource "aws_launch_template" "ec2" {
  name_prefix = "eks_worker_template"
  image_id    = data.aws_ami.ami.id

  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.s3_access.name
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

resource "aws_instance" "private" {
  launch_template {
    id = aws_launch_template.ec2.id
    version = "$Latest"
  }
}
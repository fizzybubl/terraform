data "aws_ami" "fck_nat" {
  filter {
    name   = "name"
    values = ["fck-nat-al2023-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  owners      = ["568608671756"]
  most_recent = true
}


resource "aws_security_group" "fck_nat" {
  name   = "fck_nat_sg"
  vpc_id = module.cloud_vpc.vpc_id
}


resource "aws_vpc_security_group_ingress_rule" "all_vpc" {
  security_group_id = aws_security_group.fck_nat.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.cloud_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "ec2ic" {
  security_group_id            = aws_security_group.fck_nat.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = module.ec2ic.sg_id
}


resource "aws_vpc_security_group_egress_rule" "egress_all" {
  security_group_id = aws_security_group.fck_nat.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_network_interface" "fck_nat_nic" {
  subnet_id       = module.cloud_web_rtb.subnet_id
  security_groups = [aws_security_group.fck_nat.id]

  source_dest_check = false
}

resource "aws_instance" "fck_nat" {
  ami           = data.aws_ami.fck_nat.id
  instance_type = "t4g.nano"

  network_interface {
    network_interface_id = aws_network_interface.fck_nat_nic.id
    device_index         = 0
  }
}
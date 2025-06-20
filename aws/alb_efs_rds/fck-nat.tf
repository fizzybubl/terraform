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


module "fck_nat_sg" {
  source = "../ec2/modules/security_groups"

  name        = "fck-nat-sg"
  vpc_id      = module.cloud_vpc.vpc_id
  description = "SG for FCK NAT"

  ingress_rules = {
    "fck_nat_ingress" = {
      cidr_block  = module.cloud_vpc.cidr_block
      from_port   = -1
      to_port     = -1
      description = "All from VPC"
      protocol    = -1
    }
  }

  egress_rules = {
    "fck_nat_egress" = {
      cidr_block  = "0.0.0.0/0"
      from_port   = -1
      to_port     = -1
      description = "All egress"
      protocol    = -1
    }
  }
}


resource "aws_network_interface" "fck_nat_nic" {
  subnet_id               = module.cloud_web_rtb.subnet_id
  security_groups         = [module.fck_nat_sg.sg_id]
  private_ip_list         = ["10.0.100.100"]
  private_ip_list_enabled = true

  source_dest_check = false
}


data "cloudinit_config" "fck_nat" {
  gzip = false
  part {
    filename     = "fck_nat.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/fck_nat.tpl.sh", {
      eni_id      = aws_network_interface.fck_nat_nic.id
    })
  }
}


resource "aws_instance" "fck_nat" {
  ami           = data.aws_ami.fck_nat.id
  instance_type = "t4g.nano"

  iam_instance_profile = aws_iam_instance_profile.ec2.name
  user_data = data.cloudinit_config.fck_nat.rendered

  network_interface {
    network_interface_id = aws_network_interface.fck_nat_nic.id
    device_index         = 0
  }

  depends_on = [ module.ssm ]
}
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


resource "aws_network_interface" "fck_nat_nic" {
  subnet_id               = var.subnet_id
  security_groups         = var.security_group_ids
  private_ip_list         = var.private_ip_list
  private_ip_list_enabled = true

  source_dest_check = false
}


data "cloudinit_config" "fck_nat" {
  gzip = false
  part {
    filename     = "fck_nat.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/fck_nat.tpl.sh", {
      eni_id = aws_network_interface.fck_nat_nic.id
    })
  }
}


resource "aws_instance" "fck_nat" {
  ami           = data.aws_ami.fck_nat.id
  instance_type = var.instance_type

  user_data = data.cloudinit_config.fck_nat.rendered
  primary_network_interface {
    network_interface_id = aws_network_interface.fck_nat_nic.id
  }
}
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


resource "aws_iam_role" "ec2" {
  name = "access-to-ssm"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  })
  tags = {
    "Name" : "Access To SSM"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "ec2" {
  name_prefix = "fck-nat"
  role        = aws_iam_role.ec2.name
  path        = "/"
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
  ami                  = data.aws_ami.fck_nat.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2.name
  user_data            = data.cloudinit_config.fck_nat.rendered

  network_interface {
    network_interface_id = aws_network_interface.fck_nat_nic.id
    device_index         = 0
  }
}
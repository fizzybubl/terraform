data "aws_ami" "ami" {
  filter {
    name   = "image-id"
    values = ["ami-0559679b06ebd7e58"]
  }
}


module "ec2_sg" {
  source      = "../ec2/modules/security_groups" # adjust path
  name        = "ec2-sg"
  description = "Example security group"
  vpc_id      = module.cloud_vpc.vpc_id
  tags = {
    Environment = "dev"
    Project     = "demo"
  }

  ingress_rules = {
    http = {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      security_group = module.alb_sg.sg_id
    }
    ssh = {
      description = "Allow SSH from a security group"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    }
  }

  egress_rules = {
    all_outbound = {
      description = "Allow all outbound"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    }
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

module "ec2" {
  source             = "../ec2/modules/ec2"
  instance_type      = "t2.micro"
  ami_id             = data.aws_ami.ami.id
  subnet_ids         = [for key in local.az_ids : module.cloud_app[key].subnet_id]
  security_group_ids = [module.ec2_sg.sg_id]
  user_data_base64   = data.cloudinit_config.user_data.rendered
  health_check_type  = "ELB"

  block_device_mappings = [{
    device_name = "/dev/xvda"
    ebs = {
      volume_size = 8
    }
  }]

  tags = {
    "Name" : "Test template"
  }
}
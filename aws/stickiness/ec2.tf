data "aws_ami" "ami" {
  filter {
    name   = "image-id"
    values = ["ami-0559679b06ebd7e58"]
  }
}


module "my_sg" {
  source      = "./path-to-your-module"  # adjust path
  name        = "example-sg"
  description = "Example security group"
  vpc_id      = module.cloud_vpc.vpc_id
  tags        = {
    Environment = "dev"
    Project     = "demo"
  }

  ingress_rules = {
    http = {
      description     = "Allow HTTP"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_block      = "0.0.0.0/0"           # only one destination here
    }
    ssh = {
      description     = "Allow SSH from a security group"
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_block      = "0.0.0.0/0"
    }
  }

  egress_rules = {
    all_outbound = {
      description      = "Allow all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_block       = "0.0.0.0/0"
    }
  }
}



module "ec2" {
  source = "../ec2/modules/ec2"
  instance_type = "t2.micro"
  ami_id = data.aws_ami.ami.id
  subnet_ids = [for subnet in local.cloud_app_subnets: module.cloud_app[subnet].subnet_id]
  security_group_ids = [module.my_sg.sg_id]

  block_device_mappings = [{
    device_name = "/dev/xvda"
    ebs = {
      volume_size = 8
    }
  }]
}
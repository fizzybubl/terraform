data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}


module "sg_ec2" {
  source = "../ec2/modules/security_groups"

  name        = "ec2-sg"
  vpc_id      = module.cloud_vpc.vpc_id
  description = "SG for EC2"

  ingress_rules = {
    "efs" = {
      cidr_block  = module.cloud_vpc.cidr_block
      from_port   = -1
      to_port     = -1
      description = "ALL Access"
      protocol    = -1
    }
  }

  egress_rules = {
    "all_to_vpc" = {
      cidr_block  = "0.0.0.0/0"
      from_port   = -1
      to_port     = -1
      description = "All"
      protocol    = -1
    }
  }
}


data "cloudinit_config" "user_data" {
  gzip = false
  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/user_data.tpl.sh", {
      region      = var.region
      db_pw       = var.db_pw.ssm_name
      db_endpoint = var.db_endpoint.ssm_name
      db_name     = var.db_name.ssm_name
      db_user     = var.db_user.ssm_name
      efs_id      = var.efs_id.ssm_name
    })
  }
}


module "ec2" {
  source = "../ec2/modules/ec2"

  ami_id        = data.aws_ami.ami.id
  instance      = false
  instance_type = "t2.micro"
  subnet_ids    = concat([module.cloud_app_rtb.subnet_id], [for az_id in local.az_ids : module.cloud_app[az_id].subnet_id if az_id != local.az_ids[0]])
  # subnet_ids                = [module.cloud_app_rtb.subnet_id]
  security_group_ids        = [module.sg_ec2.sg_id]
  iam_instance_profile_name = aws_iam_instance_profile.ec2.name
  desired_capacity          = 1
  health_check_type         = "ELB"

  user_data_base64 = data.cloudinit_config.user_data.rendered

  depends_on = [module.ssm, module.rds]
}
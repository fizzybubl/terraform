module "aws_vpc" {
  source               = "../vpc/modules/vpc_v3"
  igw                  = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  vpc_tags = {
    Name = "AWS VPC"
  }
}


module "aws_subnet_1" {
  source     = "../vpc/modules/subnet"
  vpc_id     = module.aws_vpc.vpc_id
  cidr_block = "10.0.1.0/24"
  az_id      = "euc1-az1"

  subnet_tags = {
    "Name" : "AWS Subnet 1"
  }
}


module "aws_subnet_2" {
  source         = "../vpc/modules/subnet"
  vpc_id         = module.aws_vpc.vpc_id
  cidr_block     = "10.0.2.0/24"
  az_id          = "euc1-az2"
  create_rtb     = false
  route_table_id = module.aws_subnet_1.route_table_id

  subnet_tags = {
    "Name" : "AWS Subnet 1"
  }
}


resource "aws_security_group" "ssm_endpoint" {
  name   = "InstanceConnectSG"
  vpc_id = module.aws_vpc.vpc_id
  tags = {
    "Name" : "InstanceConnectSG"
  }
}


resource "aws_vpc_security_group_ingress_rule" "internet_inbound" {
  security_group_id = aws_security_group.ssm_endpoint.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_vpc_security_group_egress_rule" "vpc_outbound" {
  security_group_id = aws_security_group.ssm_endpoint.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = module.aws_vpc.cidr_block
}


resource "aws_ec2_instance_connect_endpoint" "ep" {
  subnet_id          = [module.aws_subnet_1.subnet_id]
  security_group_ids = [aws_security_group.ssm_endpoint.id]
}
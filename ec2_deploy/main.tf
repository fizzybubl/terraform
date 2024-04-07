terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~>4.16"
    }
  }
}

provider "aws" {
  region = var.region
}


locals {
  public_internet = "0.0.0.0/0"
  tags = {
    Group = "Terraform"
  }
}


data "aws_ami" "amazon_ami" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "image-id"
    values = [ "ami-0f7204385566b32d0" ]
  }
}


resource "aws_vpc" "custom_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = local.tags
}


resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = local.tags
}


resource "aws_subnet" "custom_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = var.subnet_cidr_block

  tags = local.tags

  depends_on = [aws_vpc.custom_vpc]
}


resource "aws_route_table_association" "route_to_subnet_association" {
  route_table_id = aws_route_table.custom_route_table.id
  subnet_id      = aws_subnet.custom_subnet.id
}


resource "aws_security_group" "custom_security_group" {
  vpc_id = aws_vpc.custom_vpc.id
  name = "allow_vpc"
  description = "Allows all traffic from the same vpc"

  tags = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_vpc" {
  security_group_id = aws_security_group.custom_security_group.id
  cidr_ipv4 = aws_vpc.custom_vpc.cidr_block
  from_port = 0
  to_port = 0
  ip_protocol = "-1"
}


resource "aws_vpc_security_group_egress_rule" "allow_vpc" {
  security_group_id = aws_security_group.custom_security_group.id
  cidr_ipv4 = aws_vpc.custom_vpc.cidr_block
  from_port = 0
  to_port = 0
  ip_protocol = "-1"
}



resource "aws_instance" "first_ec2" {
  ami           = data.aws_ami.amazon_ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.custom_subnet.id
  vpc_security_group_ids = [ aws_security_group.custom_security_group.id ]

  depends_on = [aws_subnet.custom_subnet]
}

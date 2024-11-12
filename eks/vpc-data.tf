data "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_data.cidr_block
}


data "aws_subnets" "public_subnets" {
  filter {
    name   = "tag:Type"
    values = ["Public Subnet"]
  }
}


data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Type"
    values = ["Private Subnet"]
  }
}
data "aws_vpc" "default" {
  id = "vpc-08980c93f8ea6a745"
}


data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
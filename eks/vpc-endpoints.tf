resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.custom_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
}


resource "aws_vpc_endpoint" "ec2" {
  vpc_id       = aws_vpc.custom_vpc.id
  service_name = "com.amazonaws.${var.region}.ec2"
}


resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = aws_vpc.custom_vpc.id
  service_name = "com.amazonaws.${var.region}.ecr.api"
}


resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id       = aws_vpc.custom_vpc.id
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
}


resource "aws_vpc_endpoint" "elb" {
  vpc_id       = aws_vpc.custom_vpc.id
  service_name = "com.amazonaws.${var.region}.elasticloadbalancing"
}


resource "aws_vpc_endpoint" "xray" {
  vpc_id       = aws_vpc.custom_vpc.id
  service_name = "com.amazonaws.${var.region}.xray"
}


resource "aws_vpc_endpoint" "logs" {
  vpc_id       = aws_vpc.custom_vpc.id
  service_name = "com.amazonaws.${var.region}.logs"
}


resource "aws_vpc_endpoint" "sts" {
  vpc_id       = aws_vpc.custom_vpc.id
  service_name = "com.amazonaws.${var.region}.sts"
}

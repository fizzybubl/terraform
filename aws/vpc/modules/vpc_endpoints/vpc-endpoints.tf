resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = var.route_table_ids

  tags = {
    "Name" = "S3 VPC GW EP"
  }
}


resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_ep.id]

  tags = {
    "Name" = "EC2 VPC INTERFACE EP"
  }
}


resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_ep.id]

  tags = {
    "Name" = "ECR API VPC INTERFACE EP"
  }
}


resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_ep.id]

  tags = {
    "Name" = "ECR DKR VPC INTERFACE EP"
  }
}


resource "aws_vpc_endpoint" "elb" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.elasticloadbalancing"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_ep.id]

  tags = {
    "Name" = "ELB VPC INTERFACE EP"
  }
}


resource "aws_vpc_endpoint" "xray" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.xray"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_ep.id]

  tags = {
    "Name" = "XRAY VPC INTERFACE EP"
  }
}


resource "aws_vpc_endpoint" "logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_ep.id]

  tags = {
    "Name" = "LOGS VPC INTERFACE EP"
  }
}


resource "aws_vpc_endpoint" "sts" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_ep.id]

  tags = {
    "Name" = "STS VPC INTERFACE EP"
  }
}


# resource "aws_ec2_instance_connect_endpoint" "example" {
#   subnet_id = aws_subnet.private_subnet[0].id
# }
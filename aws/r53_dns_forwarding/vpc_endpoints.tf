
locals {
  vpcs = {
    "on_prem": module.on_prem_vpc
    "aws": module.aws_vpc
  }
}


resource "aws_security_group" "ssm_endpoint" {
  for_each = local.vpcs
  name = "InstanceConnectSG"
  vpc_id = each.value.vpc_id
  tags = {
    "Name" : "InstanceConnectSG"
  }
}


resource "aws_vpc_security_group_ingress_rule" "internet_inbound" {
  for_each = local.vpcs
  security_group_id = aws_security_group.ssm_endpoint[each.key].id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "vpc_outbound" {
  for_each = local.vpcs
  security_group_id = aws_security_group.ssm_endpoint[each.key].id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = each.value.cidr_block
}


resource "aws_ec2_instance_connect_endpoint" "ep" {
  subnet_id          = module.on_prem_subnet_1.subnet_id
  security_group_ids = [aws_security_group.ssm_endpoint.id]
}


resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = module.on_prem_vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.ssm_endpoint.id]
  subnet_ids          = [module.on_prem_subnet_1.subnet_id, module.on_prem_subnet_2.subnet_id]
}


resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = module.on_prem_vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.ssm_endpoint.id]
  subnet_ids          = [module.on_prem_subnet_1.subnet_id, module.on_prem_subnet_2.subnet_id]
}


resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id              = module.on_prem_vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.ssm_endpoint.id]
  subnet_ids          = [module.on_prem_subnet_1.subnet_id, module.on_prem_subnet_2.subnet_id]
}
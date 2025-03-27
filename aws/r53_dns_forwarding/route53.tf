locals {
  inbound_ip1 = "10.0.1.100"
  inbound_ip2 = "10.0.2.101"
}


resource "aws_route53_zone" "private" {
  name = "aws.privatezone.org"

  vpc {
    vpc_id = module.aws_vpc.vpc_id
  }
}


resource "aws_route53_record" "aws_app" {
  zone_id = aws_route53_zone.private.id
  name    = "web.aws.privaztezone.org"
  type    = "A"
  records = [aws_network_interface.aws_ec2.private_ip]
  ttl     = "60"
}


resource "aws_route53_resolver_endpoint" "inbound" {
  name                   = "inbound"
  direction              = "INBOUND"
  resolver_endpoint_type = "IPV4"

  security_group_ids = [aws_security_group.vpc_inbound.id]

  ip_address {
    subnet_id = module.aws_subnet_1.subnet_id
    ip        = local.inbound_ip1
  }

  ip_address {
    subnet_id = module.aws_subnet_2.subnet_id
    ip        = local.inbound_ip2
  }

  protocols = ["Do53", "DoH"]

  tags = {
    Name = "Inbound"
  }
}


resource "aws_route53_resolver_endpoint" "outbound" {
  name                   = "outbound"
  direction              = "OUTBOUND"
  resolver_endpoint_type = "IPV4"

  security_group_ids = [aws_security_group.vpc_outbound.id]

  ip_address {
    subnet_id = module.aws_subnet_1.subnet_id
  }

  ip_address {
    subnet_id = module.aws_subnet_2.subnet_id
  }

  protocols = ["Do53", "DoH"]

  tags = {
    Name = "Outbound"
  }
}


resource "aws_route53_resolver_rule" "outbound" {
  domain_name          = "onprem.privatezone.org"
  name                 = "outbound"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  target_ip {
    ip   = aws_network_interface.on_prem_dns1.private_ip
    port = 53
  }

  target_ip {
    ip   = aws_network_interface.on_prem_dns2.private_ip
    port = 53
  }
}


resource "aws_route53_resolver_rule_association" "outbound" {
  resolver_rule_id = aws_route53_resolver_rule.outbound.id
  vpc_id           = module.aws_vpc.vpc_id
}
resource "aws_route53_resolver_endpoint" "inbound" {
  name                   = "inbound"
  direction              = "INBOUND"
  resolver_endpoint_type = "IPV4"

  security_group_ids = [
    aws_security_group.sg1.id,
    aws_security_group.sg2.id,
  ]

  ip_address {
    subnet_id = module.aws_subnet_1.subnet_id
  }

  ip_address {
    subnet_id = module.aws_subnet_2.subnet_id
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

  security_group_ids = [
    aws_security_group.sg1.id,
    aws_security_group.sg2.id,
  ]

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

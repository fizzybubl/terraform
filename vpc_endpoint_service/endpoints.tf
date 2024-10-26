resource "aws_vpc_endpoint_service" "ep_service" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.ep_service.arn]
}


resource "aws_vpc_endpoint" "client" {
  vpc_id              = module.vpc["client"].vpc.id
  service_name        = aws_vpc_endpoint_service.ep_service.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.vpc_ep.id
  ]
}

resource "aws_vpc_endpoint_connection_accepter" "example" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.ep_service.id
  vpc_endpoint_id         = aws_vpc_endpoint.client.id
}

resource "aws_vpc_endpoint_service" "ep_service" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.ep_service.arn]
}


resource "aws_vpc_endpoint" "client" {
  vpc_id            = module.vpc["client"].vpc.id
  service_name      = aws_vpc_endpoint_service.ep_service.service_name
  vpc_endpoint_type = "Interface"

  subnet_ids = [for subnet in module.vpc["client"].private_subnets : subnet.id]
  security_group_ids = [
    module.security_group["vpc_ep"].security_group.id
  ]
}

resource "aws_vpc_endpoint_connection_accepter" "example" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.ep_service.id
  vpc_endpoint_id         = aws_vpc_endpoint.client.id
}


# resource "aws_vpc_endpoint_private_dns" "client" {
#   vpc_endpoint_id     = aws_vpc_endpoint.client.id
#   private_dns_enabled = true
#   depends_on = [ aws_vpc_endpoint_connection_accepter.example ]
# }
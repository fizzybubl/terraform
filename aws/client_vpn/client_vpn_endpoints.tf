resource "aws_ec2_client_vpn_endpoint" "example" {
  description            = "terraform-clientvpn-example"
  server_certificate_arn = aws_acm_certificate.openvpn.arn
  client_cidr_block      = "192.168.12.0/22"

  authentication_options {
    type                       = "directory-service-authentication"
    active_directory_id = aws_directory_service_directory.simple_ad.id
  }

  connection_log_options {
    enabled               = false
    # cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    # cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
  }

  dns_servers = aws_directory_service_directory.simple_ad.dns_ip_addresses
  split_tunnel = true

  vpc_id = module.cloud_vpc.vpc_id
  security_group_ids = [ aws_security_group.ec2.id ]
  session_timeout_hours = 24
  self_service_portal = "enabled"
}


resource "aws_ec2_client_vpn_network_association" "example" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.example.id
  subnet_id              = module.cloud_db_rtb.subnet_id
}


resource "aws_ec2_client_vpn_authorization_rule" "example" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.example.id
  target_network_cidr    = module.cloud_vpc.cidr_block
  authorize_all_groups   = true
}
output "endpoint_id" {
  value = aws_vpc_endpoint.this.id
}


output "sg_id" {
  value = var.security_group_ids != null ? null : aws_security_group.this[0].id
}
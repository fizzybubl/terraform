output "route_table_id" {
  value = var.create_rtb ? aws_route_table.this[0].id : var.route_table_id
}

output "subnet_id" {
  value = aws_subnet.this.id
}
output "public_subnets" {
  value = aws_subnet.public_subnet
}


output "private_subnets" {
  value = aws_subnet.private_subnet
}


output "vpc" {
  value = aws_vpc.custom_vpc
}


output "route_tables" {
  value = {
    public_route_table  = aws_route_table.public_route_table
    private_route_table = aws_route_table.private_route_table
  }
}
output "vpc_id" {
  value = aws_vpc.this.id
}

output "igw_id" {
  value = aws_internet_gateway.this[0].id
}
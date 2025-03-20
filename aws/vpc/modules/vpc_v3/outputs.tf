output "vpc_id" {
  value = aws_vpc.this.id
}


output "cidr_block" {
  value = aws_vpc.this.cidr_block
}


output "igw_id" {
  value = var.igw ? aws_internet_gateway.this[0].id : null
}
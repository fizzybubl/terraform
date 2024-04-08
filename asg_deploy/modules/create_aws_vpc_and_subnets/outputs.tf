output "vpc" {
    value = aws_vpc.custom_vpc
}

output "private_subnets" {
    value = aws_subnet.private_subnet
}

output "public_subnets" {
    value = aws_subnet.public_subnet
}
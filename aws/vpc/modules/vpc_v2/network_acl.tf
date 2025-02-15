# resource "aws_network_acl" "private" {
#   vpc_id = local.vpc_id
# }


# resource "aws_network_acl_rule" "private" {
#   network_acl_id = aws_network_acl.private.id
#   rule_number    = 200
#   egress         = false
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = aws_vpc.foo.cidr_block
#   from_port      = 22
#   to_port        = 22
# }


# locals {
#     public_subnet_ids = lookup(var.public_network_acl, "subnet_ids", null)
# }


# resource "aws_network_acl" "public" {
#   count = var.create_public_acl ? 1 : 0

#   vpc_id = local.vpc_id

#   subnet_ids = lookup(var.public_network_acl, "subnet_ids", aws_subnet.public[*].id)
# }


# resource "aws_network_acl_rule" "public" {
#   network_acl_id = aws_network_acl.public.id
#   rule_number    = 200
#   egress         = false
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = aws_vpc.foo.cidr_block
#   from_port      = 22
#   to_port        = 22
# }

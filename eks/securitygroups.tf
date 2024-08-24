resource "aws_security_group" "control_plane" {
  name   = "control_plane_sg"
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_security_group" "worker_nodes" {
  name   = "worker_nodes_sg"
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "worker_nodes_access" {
  security_group_id            = aws_security_group.control_plane.id
  ip_protocol                  = "tcp"
  from_port                    = 1
  to_port                      = 65535
  referenced_security_group_id = aws_security_group.worker_nodes.id
}


resource "aws_vpc_security_group_ingress_rule" "user_access" {
  security_group_id = aws_security_group.control_plane.id
  ip_protocol       = "tcp"
  from_port         = 1
  to_port           = 65535
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "control_plane_access" {
  security_group_id            = aws_security_group.worker_nodes.id
  ip_protocol                  = "tcp"
  from_port                    = 1
  to_port                      = 65535
  referenced_security_group_id = aws_security_group.control_plane.id
}


resource "aws_vpc_security_group_ingress_rule" "vpc_access" {
  security_group_id = aws_security_group.worker_nodes.id
  ip_protocol       = "tcp"
  from_port         = 1
  to_port           = 65535
  cidr_ipv4         = aws_vpc.custom_vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "internet_access" {
  security_group_id = aws_security_group.worker_nodes.id
  ip_protocol       = "tcp"
  from_port         = 1
  to_port           = 65535
  cidr_ipv4         = "0.0.0.0/0"
}
locals {
  common_sg_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "aws:eks:cluster-name"                      = var.cluster_name
    "Name"                                      = "eks-cluster-sg-${var.cluster_name}"
  }

  control_plange_required_egress = [{ port = 443, protocol = "tcp" }, { port = 53, protocol = "tcp" }, { port = 53, protocol = "udp" }, { port = 10250, protocol = "tcp" }]
}

resource "aws_security_group" "control_plane" {
  name   = "control_plane_sg"
  vpc_id = aws_vpc.custom_vpc.id

  tags = local.common_sg_tags
}

resource "aws_security_group" "worker_nodes" {
  name   = "worker_nodes_sg"
  vpc_id = aws_vpc.custom_vpc.id

  tags = local.common_sg_tags
}

resource "aws_vpc_security_group_ingress_rule" "worker_nodes_access" {
  security_group_id = aws_security_group.control_plane.id
  ip_protocol       = "tcp"
  from_port         = 1
  to_port           = 65535
  cidr_ipv4         = aws_vpc.custom_vpc.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "user_access" {
  for_each          = var.authorised_ips
  security_group_id = aws_security_group.control_plane.id
  ip_protocol       = "tcp"
  from_port         = 1
  to_port           = 65535
  cidr_ipv4         = each.value
}


resource "aws_vpc_security_group_ingress_rule" "control_plane_access" {
  security_group_id = aws_security_group.worker_nodes.id
  ip_protocol       = "tcp"
  from_port         = 1
  to_port           = 65535
  cidr_ipv4         = aws_vpc.custom_vpc.cidr_block
}


# resource "aws_vpc_security_group_egress_rule" "internet_access" {
#   security_group_id = aws_security_group.worker_nodes.id
#   ip_protocol       = "tcp"
#   from_port         = 1
#   to_port           = 65535
#   cidr_ipv4         = "0.0.0.0/0"
# }


resource "aws_vpc_security_group_egress_rule" "control_plane_egress" {
  count                        = length(local.control_plange_required_egress)
  security_group_id            = aws_security_group.control_plane.id
  ip_protocol                  = local.control_plange_required_egress[count.index].protocol
  from_port                    = local.control_plange_required_egress[count.index].port
  to_port                      = local.control_plange_required_egress[count.index].port
  referenced_security_group_id = aws_security_group.control_plane.id
}
# Cluster security group
resource "aws_security_group" "eks" {
  name   = "ClusterSecurityGroup"
  vpc_id = data.aws_vpc.custom_vpc.id

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "aws:eks:cluster-name"                      = var.cluster_name
    "Name"                                      = "eks-cluster-sg-${var.cluster_name}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_inbound_access" {
  security_group_id = aws_security_group.eks.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = data.aws_vpc.custom_vpc.cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "internet_inbound_access" {
  for_each          = var.authorised_ips
  security_group_id = aws_security_group.eks.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = each.value
}


resource "aws_vpc_security_group_egress_rule" "vpc_outbound_access" {
  security_group_id = aws_security_group.eks.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = data.aws_vpc.custom_vpc.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "internet_outbound_access" {
  security_group_id = aws_security_group.eks.id
  ip_protocol       = -1
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
}

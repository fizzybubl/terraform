resource "aws_eks_access_entry" "this" {
  for_each          = var.access_entries
  cluster_name      = aws_eks_cluster.this.name
  principal_arn     = each.value.principal_arn
  kubernetes_groups = each.value.kubernetes_groups
  type              = each.value.type
}


resource "aws_eks_access_policy_association" "this" {
  for_each      = var.access_entries_policies
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.principal_arn
  policy_arn    = each.value.policy_arn
  access_scope {
    type       = each.value.access_scope.type
    namespaces = each.value.access_scope.namespaces
  }
}
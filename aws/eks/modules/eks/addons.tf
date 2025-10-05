resource "aws_eks_addon" "this" {
  for_each                 = var.addons
  cluster_name             = aws_eks_cluster.this.name
  addon_name               = each.value.addon_name
  addon_version            = each.value.addon_version
  service_account_role_arn = each.value.role_arn
  dynamic "pod_identity_association" {
    for_each = each.value.pod_identity_association != null ? [each.value.pod_identity_association] : []
    iterator = pia
    content {
      service_account = pia.value.service_account
      role_arn        = pia.value.role_arn
    }
  }
}
resource "aws_iam_role" "addon" {
  for_each = local.addons_with_irsa
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.cluster_oidc.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:aud" : "sts.amazonaws.com",
            "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:sub" : "system:serviceaccount:kube-system:${local.addon_to_sa[each.key]}"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "addon_policy" {
  for_each   = local.addons_with_irsa
  role       = aws_iam_role.addon[each.key].name
  policy_arn = each.value.policy_arn
}


resource "aws_eks_addon" "this" {
  for_each                 = var.addons
  cluster_name             = aws_eks_cluster.this.name
  addon_name               = each.key
  addon_version            = each.value.version
  service_account_role_arn = aws_iam_role.addon[each.key].arn
  dynamic "pod_identity_association" {
    for_each = each.value.pod_identity_association != null ? [each.value.pod_identity_association] : []
    iterator = pia
    content {
      service_account = pia.value.service_account
      role_arn        = pia.value.role_arn
    }
  }
}
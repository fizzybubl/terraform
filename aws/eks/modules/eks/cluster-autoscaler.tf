resource "helm_release" "autoscaler" {
  chart            = "https://kubernetes.github.io/autoscaler/cluster-autoscaler"
  name             = "cluster-autoscaler"
  atomic           = true
  namespace        = "infra"
  create_namespace = true
  values = [coalesce(var.cluster_autoscaler_values,
    templatefile("${path.module}/files/cluster_autoscaler.yaml",
      {
        cluster_name            = var.cluster_name,
        eks_version             = var.version,
        region                  = var.region,
        cluster_autoscaler_role = aws_iam_role.cluster_autoscaler.arn
    })
  )]
}
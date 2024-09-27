resource "kubernetes_service_account" "autoscaler_sa" {
  metadata {
    labels = local.labels

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
    }

    namespace = var.namespace
    name      = local.name
  }
}


resource "kubernetes_cluster_role" "autoscaler_c_role" {
  metadata {
    labels = local.labels
    name   = local.name
  }

  rule {
    api_groups = [""]
    verbs      = ["create", "patch"]
    resources  = ["events", "endpoints"]
  }

  rule {
    api_groups = [""]
    verbs      = ["create"]
    resources  = ["pods/evictions"]
  }

  rule {
    api_groups = [""]
    verbs      = ["update"]
    resources  = ["pods/status"]
  }

  rule {
    api_groups     = [""]
    resource_names = ["cluster-autoscaler"]
    resources      = ["endpoints"]
    verbs          = ["get", "update"]
  }

  rule {
    api_groups = [""]
    verbs      = ["watch", "list", "get", "update"]
    resources  = ["nodes"]
  }

  rule {
    api_groups = [""]
    verbs      = ["watch", "list", "get"]
    resources  = ["namespaces", "pods", "services", "replicationcontroller", "persistentvolumeclaims", "persistentvolumes"]
  }

  rule {
    api_groups = ["extensions"]
    verbs      = ["watch", "list", "get"]
    resources  = ["replicasets", "daemonsets"]
  }

  rule {
    api_groups = ["policy"]
    verbs      = ["watch", "list"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    api_groups = ["apps"]
    verbs      = ["watch", "list", "get"]
    resources  = ["replicasets", "daemonsets", "statefulsets"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "csinodes", "csidrivers", "csistoragecapacities"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["batch", "extensions"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "watch", "patch"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create"]
  }

  rule {
    api_groups     = ["coordination.k8s.io"]
    resource_names = ["cluster-autoscaler"]
    resources      = ["leases"]
    verbs          = ["get", "update"]
  }
}


resource "kubernetes_role" "autoscaler_role" {
  metadata {
    labels = local.labels
    name   = local.name
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create", "list", "watch"]
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
    verbs          = ["delete", "get", "update", "watch"]
  }
}


resource "kubernetes_cluster_role_binding" "autoscaler_c_role_bind" {
  metadata {
    labels = local.labels
    name   = local.name
  }

  role_ref {
    name      = kubernetes_cluster_role.autoscaler_c_role.metadata[0].name
    kind      = "ClusterRole"
    api_group = local.rbac_api_group
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.autoscaler_sa.metadata[0].name
  }
}


resource "kubernetes_role_binding" "autoscaler_role_bind" {
  metadata {
    labels    = local.labels
    name      = local.name
    namespace = var.namespace
  }

  role_ref {
    name      = kubernetes_cluster_role.autoscaler_c_role.metadata[0].name
    kind      = "Role"
    api_group = local.rbac_api_group
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.autoscaler_sa.metadata[0].name
  }
}
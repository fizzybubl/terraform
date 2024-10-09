locals {
  labels = {
    "k8s-app" = "metrics-server"
  }
  rbac_api_group = "rbac.authorization.k8s.io"
  namespace      = "kube-system"
}


resource "kubernetes_service_account_v1" "metrics_server" {
  metadata {
    labels    = local.labels
    name      = "metrics-server"
    namespace = local.namespace
  }
}


resource "kubernetes_cluster_role_v1" "aggregated_metrics_reader" {
  metadata {
    labels = {
      "k8s-app" : local.labels["k8s-app"],
      "rbac.authorization.k8s.io/aggregate-to-admin" : "true",
      "rbac.authorization.k8s.io/aggregate-to-edit" : "true",
      "rbac.authorization.k8s.io/aggregate-to-view" : "true"
    }
    name = "system:aggregated-metrics-reader"
  }

  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}


resource "kubernetes_cluster_role_v1" "metrics_server" {

  metadata {
    labels = {
      "k8s-app" : local.labels["k8s-app"],
      "rbac.authorization.k8s.io/aggregate-to-admin" : "true",
      "rbac.authorization.k8s.io/aggregate-to-edit" : "true",
      "rbac.authorization.k8s.io/aggregate-to-view" : "true"
    }
    name = "system:metrics-server"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes/metrics"]
    verbs      = ["get"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}


resource "kubernetes_role_binding_v1" "metrics_server_auth_reader" {
  metadata {
    labels    = local.labels
    name      = "metrics-server-auth-reader"
    namespace = local.namespace
  }

  role_ref {
    api_group = local.rbac_api_group
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = local.namespace
  }
}


resource "kubernetes_cluster_role_binding_v1" "auth_delegator" {
  metadata {
    labels = local.labels
    name   = "metrics-server:system:auth-delegator"
  }

  role_ref {
    api_group = local.rbac_api_group
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = local.namespace
  }
}


resource "kubernetes_cluster_role_binding_v1" "metrics_server" {
  metadata {
    labels = local.labels
    name   = "system:metrics-server"
  }

  role_ref {
    api_group = local.rbac_api_group
    kind      = "ClusterRole"
    name      = "system:metrics-server"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "metrics-server"
    namespace = local.namespace
  }
}


resource "kubernetes_service_v1" "metrics_server" {
  metadata {
    labels    = local.labels
    name      = "metrics-server"
    namespace = local.namespace
  }

  spec {
    port {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = "https"
    }
    selector = local.labels
  }
}


resource "kubernetes_deployment_v1" "metrics_server" {
  metadata {
    labels    = local.labels
    name      = "metrics-server"
    namespace = local.namespace
  }

  spec {
    selector {
      match_labels = local.labels
    }

    strategy {
      rolling_update {
        max_unavailable = 0
      }
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        container {
          args = ["--cert-dir=/tmp",
            "--secure-port=10250",
            "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
            "--kubelet-use-node-status-port",
          "--metric-resolution=15s"]

          name              = "metrics-server"
          image             = "registry.k8s.io/metrics-server/metrics-server:v0.7.2"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = "10250"
            name           = "https"
            protocol       = "TCP"
          }

          liveness_probe {
            failure_threshold = 3
            http_get {
              path   = "/livez"
              port   = "https"
              scheme = "HTTPS"
            }
            period_seconds = 10
          }

          readiness_probe {
            failure_threshold = 3
            http_get {
              path   = "/readyz"
              port   = "https"
              scheme = "HTTPS"
            }
            initial_delay_seconds = 20
            period_seconds        = 10
          }

          resources {
            requests = {
              "cpu" : "100m",
              "memory" : "200Mi"
            }
          }

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            read_only_root_filesystem = true
            run_as_non_root           = true
            run_as_user               = 1000
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }

          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-dir"
          }
        }

        node_selector = {
          "kubernetes.io/os" : "linux"
        }

        priority_class_name  = "system-cluster-critical"
        service_account_name = "metrics-server"

        volume {
          empty_dir {

          }
          name = "tmp-dir"
        }
      }
    }
  }

  depends_on = [ aws_eks_node_group.worker_nodes ]
}


resource "kubernetes_api_service_v1" "metrics_server" {
  metadata {
    labels = local.labels
    name   = "v1beta1.metrics.k8s.io"
  }

  spec {
    group                    = "metrics.k8s.io"
    group_priority_minimum   = 100
    insecure_skip_tls_verify = true
    service {
      name      = "metrics-server"
      namespace = local.namespace
    }
    version          = "v1beta1"
    version_priority = 100
  }

  depends_on = [ aws_eks_node_group.worker_nodes ]
}
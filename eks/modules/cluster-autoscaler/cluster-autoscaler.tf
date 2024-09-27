resource "kubernetes_deployment" "cluster_autoscaler" {
  metadata {
    name      = local.name
    namespace = var.namespace
    labels = {
      "app" = local.name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app" = local.name
      }
    }

    template {
      metadata {
        labels = {
          "app" = local.name
        }

        annotations = {
          "prometheus.io/scrape" = true
          "prometheus.io/port"   = 8085
          "cluster-autoscaler.kubernetes.io/safe-to-evict" = false
          "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
        }
      }

      spec {
        priority_class_name = "system-cluster-critical"

        dynamic "affinity" {
          for_each = length(var.mixin_instances) > 0 ? range(1) : range(0)
          content {
            node_affinity {
              required_during_scheduling_ignored_during_execution {
                node_selector_term {
                  match_expressions {
                    key      = "beta.kubernetes.io/instance-type"
                    operator = "In"
                    values   = affinity.value
                  }
                }
              }
            }
          }
        }

        security_context {
          run_as_non_root = true
          run_as_user     = "65534"
          run_as_group    = "65534"

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        service_account_name = kubernetes_service_account.autoscaler_sa.metadata[0].name

        container {
          name  = local.name
          image = "registry.k8s.io/autoscaling/cluster-autoscaler:v1.26.2"

          resources {
            limits = {
              cpu    = "100m"
              memory = "600Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "600Mi"
            }
          }

          command = [
            "./cluster-autoscaler",
            "--v=4",
            "--stderrthreshold=info",
            "--cloud-provider=aws",
            "--skip-nodes-with-local-storage=false",
            "--expander=least-waste",
            "--aws-use-static-instance-list=false",
            "--balance-similar-node-groups",
            "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${var.control_plane.id}"
          ]

          env {
            name = "AWS_REGION"
            value = data.aws_region.current.name
          }

          env {
            name = "AWS_STS_REGIONAL_ENDPOINTS"
            value = "regional"
          }

          volume_mount {
            name       = local.volume_name
            mount_path = "/etc/ssl/certs/ca-certificates.crt"
            read_only  = true
          }

          image_pull_policy = "Always"

          security_context {
            allow_privilege_escalation = false

            capabilities {
              drop = ["ALL"]
            }

            read_only_root_filesystem = true
          }
        }

        volume {
          name = local.volume_name
          host_path {
            path = "/etc/ssl/certs/ca-bundle.crt"
          }
        }
      }
    }
  }
}
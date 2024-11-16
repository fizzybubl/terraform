output "cluster_autoscaler" {
    value = kubernetes_deployment.cluster_autoscaler
}


output "cluster_autoscaler_sa" {
    value = kubernetes_service_account.autoscaler_sa
}


output "cluster_autoscaler_iam_role" {
    value = aws_iam_role.cluster_autoscaler
}
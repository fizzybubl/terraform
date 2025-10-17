# resource "helm_release" "autoscaler" {
#   repository       = "https://kubernetes.github.io/autoscaler"
#   chart            = "cluster-autoscaler"
#   name             = "cluster-autoscaler"
#   atomic           = true
#   namespace        = "infra"
#   create_namespace = true
#   values = [templatefile("${path.module}/files/cluster_autoscaler.yaml",
#       {
#         cluster_name            = aws_eks_cluster.this.id,
#         eks_version             = var.eks_version,
#         region                  = var.region,
#         cluster_autoscaler_role = aws_iam_role.cluster_autoscaler.arn
#     })]

#   depends_on = [ aws_eks_node_group.this ]
# }


data "aws_caller_identity" "current" {}

resource "aws_iam_role" "cluster_autoscaler" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.cluster_oidc.arn
        },
        "Condition" : {
          "StringEquals" : {
            "${local.oidc_issuer}:sub" : "system:serviceaccount:infra:cluster-autoscaler"
          }
        }
      }
    ]
    }
  )
}



resource "aws_iam_policy" "cluster_autoscaler" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ClusterAutoscalerAll",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes"
        ],
        "Resource" : "*"
      }
    ]
    }
  )
  name = "Cluster-Autoscaler"
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}


output "cluster_autoscaler" {
  value = templatefile("${path.module}/files/cluster_autoscaler.yaml",
    {
      cluster_name            = aws_eks_cluster.this.id,
      eks_version             = var.eks_version,
      region                  = var.region,
      cluster_autoscaler_role = aws_iam_role.cluster_autoscaler.arn
  })
}
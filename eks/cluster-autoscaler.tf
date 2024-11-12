# module "cluster_autoscaler" {
#   source = "./modules/cluster-autoscaler"
#   openid_connect_provider = {
#     arn = aws_iam_openid_connect_provider.control_plane.arn
#   }
#   control_plane = {
#     issuer = aws_eks_cluster.control_plane.identity.0.oidc.0.issuer
#     id     = aws_eks_cluster.control_plane.id
#   }
# }

# Cluster Autoscaler policies

# data "aws_iam_policy_document" "cluster_autoscaler" {
#   statement {
#     sid    = "ClusterAutoscalerAll"
#     effect = "Allow"

#     actions = [
#       "autoscaling:DescribeAutoScalingGroups",
#       "autoscaling:DescribeAutoScalingInstances",
#       "autoscaling:DescribeInstances",
#       "autoscaling:DescribeLaunchConfigurations",
#       "autoscaling:DescribeTags",
#       "autoscaling:SetDesiredCapacity",
#       "autoscaling:TerminateInstanceInAutoScalingGroup",
#       "ec2:DescribeLaunchTemplateVersions",
#       "ec2:DescribeInstances",
#       "ec2:DescribeInstanceTypes"
#     ]

#     resources = ["*"]
#   }
# }


# data "aws_iam_policy_document" "cluster_autoscaler_assume" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.control_plane.arn]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_eks_cluster.control_plane.identity[0].oidc[0].issuer, "https://", "")}:sub"
#       values   = ["system:serviceaccount:infra:cluster-autoscaler"]
#     }

#     effect = "Allow"
#   }
# }


# resource "aws_iam_role" "cluster_autoscaler" {
#   name               = "${aws_eks_cluster.control_plane.id}-cluster-autoscaler"
#   assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume.json
# }


# resource "aws_iam_policy" "cluster_autoscaler" {
#   policy = data.aws_iam_policy_document.cluster_autoscaler.json
#   name   = "Cluster-Autoscaler"
# }

# resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
#   role       = aws_iam_role.cluster_autoscaler.name
#   policy_arn = aws_iam_policy.cluster_autoscaler.arn
# } 
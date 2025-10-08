data "aws_caller_identity" "current" {}

resource "aws_iam_role" "cluster_autoscaler" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::${aws_caller_identity.current.account_id}:oidc-provider/${replace(var.control_plane.issuer, "https://", "")}:sub"
        },
        "Condition" : {
          "StringEquals" : {
            "<OIDC_PROVIDER>:sub" : "system:serviceaccount:infra:cluster-autoscaler"
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
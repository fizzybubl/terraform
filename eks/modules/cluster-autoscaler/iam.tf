data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "ClusterAutoscalerAll"
    effect = "Allow"

    actions = [
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
    ]

    resources = ["*"]
  }
}


data "aws_iam_policy_document" "cluster_autoscaler_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.openid_connect_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.control_plane.issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:infra:cluster-autoscaler"]
    }

    effect = "Allow"
  }
}


resource "aws_iam_role" "cluster_autoscaler" {
  name               = "${var.control_plane.id}-cluster-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume.json
}


resource "aws_iam_policy" "cluster_autoscaler" {
  policy = data.aws_iam_policy_document.cluster_autoscaler.json
  name   = "Cluster-Autoscaler"
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}
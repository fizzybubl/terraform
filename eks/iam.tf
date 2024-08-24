# Control plane policies
data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  name = "AmazonEKSClusterPolicy"
}


data "aws_iam_policy" "AmazonEKSServicePolicy" {
  name = "AmazonEKSServicePolicy"
}


resource "aws_iam_role" "eks_cluster_role" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
}


resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks_cluster_role.arn
  policy_arn = data.aws_iam_policy.AmazonEKSServicePolicy.arn
}


resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.arn
  policy_arn = data.aws_iam_policy.AmazonEKSClusterPolicy.arn
}


# Worker policies
data "aws_iam_policy_document" "worker_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "worker" {
  name               = "TestCluster"
  assume_role_policy = data.aws_iam_policy_document.worker_assume_role.json
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.example.name
}


# Cluster Autoscaler policies
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
      identifiers = [aws_iam_openid_connect_provider.control_plane.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.control_plane.identity.0.oidc.0.issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:infra:cluster-autoscaler"]
    }

    effect = "Allow"
  }
}


resource "aws_iam_role" "cluster_autoscaler" {
  name               = "${aws_eks_cluster.control_plane.id}-cluster-autoscaler"
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
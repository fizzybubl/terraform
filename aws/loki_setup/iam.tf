resource "aws_iam_role" "loki_access" {
  name = "LokiServiceAccountRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : module.eks.oidc_issuer.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${module.eks.oidc_issuer.url}:aud" : "sts.amazonaws.com",
            "${module.eks.oidc_issuer.url}:sub" : "system:serviceaccount:loki:loki"
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "loki_access" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "LokiStorage",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          module.chunks_bucket.bucket.arn,
          "${module.chunks_bucket.bucket.arn}/*",
          module.ruler_bucket.bucket.arn,
          "${module.ruler_bucket.bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "loki_access" {
  role       = aws_iam_role.loki_access.name
  policy_arn = aws_iam_policy.loki_access.arn
}
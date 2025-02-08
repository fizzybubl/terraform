resource "aws_iam_role" "federated_s3_access" {
  name = "FederatedS3Access"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "cognito-identity.amazonaws.com"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "cognito-identity.amazonaws.com:aud" : "${aws_cognito_identity_pool.cloudfront.id}"
          },
          "ForAnyValue:StringLike" : {
            "cognito-identity.amazonaws.com:amr" : "authenticated"
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "federated_s3_access" {
  name = "FederatedS3Access"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        "Resource" : [
          "${module.privatepatches.bucket.arn}",
          "${module.privatepatches.bucket.arn}/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "federated_s3_access" {
  role       = aws_iam_role.federated_s3_access.name
  policy_arn = aws_iam_policy.federated_s3_access.arn
}
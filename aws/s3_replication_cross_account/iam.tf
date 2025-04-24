resource "aws_iam_role" "allow_prod_to_replicate_to_dev" {
  provider = aws.prod
  name     = "AllowProdToReplicateToDev"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "Name" : "AllowProdToReplicateToDev"
  }
}

resource "aws_iam_policy" "allow_prod_to_replicate_to_dev" {
  provider = aws.prod
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        "Resource" : module.prod.bucket.arn
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ],
        "Resource" : "${module.prod.bucket.arn}/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        "Resource" : "${module.dev.bucket.arn}/*"
      }
    ]
  })

  tags = {
    "Name" : "AllowProdToReplicateToDev"
  }
}


resource "aws_iam_role_policy_attachment" "allow_prod_to_replicate_to_dev" {
  provider   = aws.prod
  role       = aws_iam_role.allow_prod_to_replicate_to_dev.name
  policy_arn = aws_iam_policy.allow_prod_to_replicate_to_dev.arn
}
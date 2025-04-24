data "aws_caller_identity" "current" {}

data "aws_iam_role" "admin_dev" {
  name = "Administrator"
}

module "s3_encryption" {
  alias        = "s3_encryption"
  multi_region = false
  source       = "../kms/modules/kms"
  key_policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_role.admin_dev.arn
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Allow S3 access to the key"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com" # TODO
        },
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:CallerAccount" : data.aws_caller_identity.current.account_id,
            "kms:ViaService" : "s3.${var.region}.amazonaws.com"
          }
        }
      }
    ]
  })
}

module "encrypted" {
  source                  = "../s3/modules/bucket"
  bucket_prefix           = "encrypted-kms-test"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Enabled"
  sse_alg                 = "aws:kms"
  key_arn                 = module.s3_encryption.alias.arn
  bucket_key              = var.bucket_key
}


resource "aws_s3_bucket_policy" "prod" {
  bucket = module.encrypted.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow Admin"
        "Principal" : {
          "AWS" : "${data.aws_iam_role.admin_dev.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : ["${module.encrypted.bucket.arn}", "${module.encrypted.bucket.arn}/*"],
      },
      {
        Sid       = "DenyIncorrectEncryptionHeader"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${module.encrypted.bucket.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "aws:kms"
          }
        }
      },
      {
        Sid       = "DenyUnEncryptedObjectUploads"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${module.encrypted.bucket.arn}/*"
        Condition = {
          Null = {
            "s3:x-amz-server-side-encryption" = "true"
          }
        }
      }
    ]
  })
}




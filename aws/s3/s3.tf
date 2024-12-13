data "aws_iam_role" "admin" {
  name = "Administrator"
}


module "s3_bucket" {
  source = "./modules/bucket"
  bucket = "test-bucket-module-tf"
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}


module "s3_bucket_policy" {
  source    = "./modules/bucket_policy"
  bucket_id = module.s3_bucket.bucket.id
  bucket_policy = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Principal" : {
          "AWS" : "${data.aws_iam_role.admin.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : "${module.s3_bucket.bucket.arn}",
      }
    ]
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "logs_rule"

    filter {
      prefix = "logs/"
    }

    transition {
      days = 365
      storage_class = "GLACIER_IR"
    }

    status = "Enabled"
  }

  rule {
    id = "rule-2"

    filter {
      prefix = "tmp/"
    }

    # ... other transition/expiration actions ...

    status = "Enabled"
  }
}
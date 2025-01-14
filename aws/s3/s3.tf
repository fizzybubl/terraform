data "aws_iam_role" "admin" {
  name = "Administrator"
}


module "s3_bucket" {
  source = "./modules/bucket"
  bucket = "custom-logs-for-analysis"
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
  versioning = "Disabled"
}


resource "aws_s3_bucket_policy" "policy" {
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


resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "logs_rule"

    filter {
      prefix = "logs/"
    }

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 90
      storage_class = "GLACIER"
    }

    transition {
      days = 365
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 730
    }

    status = "Enabled"
  }
}


module "upload_bucket" {
  source = "./modules/bucket"
  bucket = "upload_bucket"
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
  versioning = "Enabled"
}


resource "aws_s3_bucket_policy" "policy_upload" {
  bucket_id = module.upload_bucket.bucket.id
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
        "Resource" : "${module.upload_bucket.bucket.arn}",
      }
    ]
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "upload" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "archive"

    filter {}

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 90
      storage_class = "GLACIER"
    }

    transition {
      days = 365
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 730
    }

    status = "Enabled"
  }

  rule {
    id = "archive"

    filter {}

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 90
      storage_class = "GLACIER"
    }

    transition {
      days = 365
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 730
    }

    status = "Enabled"
  }
}
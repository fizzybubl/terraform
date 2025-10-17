data "aws_caller_identity" "current" {
}


module "chunks_bucket" {
  source                  = "../s3/modules/bucket"
  bucket                  = "loki-test-chunks-bucket"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Disabled"
}


resource "aws_s3_bucket_policy" "chunks_bucket" {
  bucket = module.chunks_bucket.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Principal" : {
          "AWS" : "${data.aws_caller_identity.current.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : "${module.chunks_bucket.bucket.arn}/*",
      },
      {
        "Principal" : {
          "AWS" : "${aws_iam_role.loki_access.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : "${module.chunks_bucket.bucket.arn}/*",
      }
    ]
  })
}


module "ruler_bucket" {
  source                  = "../s3/modules/bucket"
  bucket                  = "loki-test-chunks-bucket"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Disabled"
}


resource "aws_s3_bucket_policy" "ruler_bucket" {
  bucket = module.ruler_bucket.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Principal" : {
          "AWS" : "${data.aws_caller_identity.current.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : "${module.ruler_bucket.bucket.arn}/*",
      },
      {
        "Principal" : {
          "AWS" : "${aws_iam_role.loki_access.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : "${module.ruler_bucket.bucket.arn}/*",
      }
    ]
  })
}

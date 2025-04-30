module "dev" {
  source                  = "../s3/modules/bucket"
  bucket                  = "destination-dev-test-sdd"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Enabled"
}


resource "aws_s3_bucket_policy" "dev" {
  bucket   = module.dev.bucket.id
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
        "Resource" : ["${module.dev.bucket.arn}", "${module.dev.bucket.arn}/*"]
      },
      {
        "Effect": "Allow",
        "Principal" : { "AWS": "*" },
        "Action" : "s3:*",
        "Resource" : ["${module.dev.bucket.arn}", "${module.dev.bucket.arn}/*"],
        "Condition": {
            "StringEquals" : { "s3:DataAccessPointArn" : [aws_s3_access_point.e2e.arn, aws_s3_access_point.dev.arn] }
        }
    }
    ]
  })
}

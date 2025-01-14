data "aws_iam_role" "admin" {
  name = "Administrator"
}


module "s3_bucket" {
  source = "../s3/modules/bucket"
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

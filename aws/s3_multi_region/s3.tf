data "aws_iam_role" "admin" {
  name = "Administrator"
}


module "frankfurt" {
  source                  = "../s3/modules/bucket"
  bucket                  = "frankfurt-test-bucket-asdagsahfd"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Enabled"
}


module "dublin" {
  source                  = "../s3/modules/bucket"
  bucket                  = "dublin-test-bucket-asdagsahfd"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Enabled"

  providers = {
    aws = aws.west
  }
}


resource "aws_s3_bucket_policy" "frankfurt" {
  bucket = module.frankfurt.bucket.id
  policy = jsonencode({
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
        "Resource" : "${module.frankfurt.bucket.arn}",
      }
    ]
  })
}


resource "aws_s3_bucket_policy" "dublin" {
  provider = aws.west
  bucket   = module.dublin.bucket.id
  policy = jsonencode({
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
        "Resource" : "${module.dublin.bucket.arn}",
      }
    ]
  })
}

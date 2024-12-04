data "aws_iam_role" "admin" {
  name = "Administrator"
}


module "s3_bucket" {
  source = "./modules/bucket"
  bucket = "test-bucket-module-tf"
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

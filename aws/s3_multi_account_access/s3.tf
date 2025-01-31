locals {
  buckets_objects = {
    petpics1 = {
      obj                     = "ginny.jpg",
      block_public_acls       = true
      block_public_policy     = true
      restrict_public_buckets = true
      ignore_public_acls      = true
    },
    petpics2 = {
      obj                     = "hermione.jpg",
      block_public_acls       = true
      block_public_policy     = true
      restrict_public_buckets = true
      ignore_public_acls      = true
    },
    petpics3 = {
      obj                     = "maxi.jpg",
      block_public_acls       = true
      block_public_policy     = true
      restrict_public_buckets = true
      ignore_public_acls      = true
    }
  }

  buckets_to_upload = ["petpics1", "petpics2"]
}


module "multi_account_access" {
  for_each                = local.buckets_objects
  source                  = "../s3/modules/bucket"
  bucket_prefix           = each.key
  block_public_acls       = each.value.block_public_acls
  block_public_policy     = each.value.block_public_policy
  restrict_public_buckets = each.value.restrict_public_buckets
  ignore_public_acls      = each.value.ignore_public_acls
  versioning              = "Disabled"
  force_destroy           = true
}


resource "aws_s3_bucket_policy" "petpics1" {
  bucket = module.multi_account_access["petpics1"].bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Principal" : {
          "AWS" : "${data.aws_caller_identity.management.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:ListBucket",
          "s3:GetObjectTagging",
          "s3:DeleteObject",
          "s3:PutObjectTagging"
        ],
        "Resource" : [
          "${module.multi_account_access["petpics1"].bucket.arn}",
          "${module.multi_account_access["petpics1"].bucket.arn}/*"
        ],
      }
    ]
  })
}


resource "aws_s3_bucket_policy" "petpics2" {
  bucket = module.multi_account_access["petpics2"].bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Principal" : {
          "AWS" : "${data.aws_caller_identity.management.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:ListBucket",
          "s3:GetObjectTagging",
          "s3:DeleteObject",
          "s3:PutObjectTagging"
        ],
        "Resource" : [
          "${module.multi_account_access["petpics2"].bucket.arn}",
          "${module.multi_account_access["petpics2"].bucket.arn}/*"
        ],
      }
    ]
  })
}


resource "aws_s3_bucket_policy" "petpics3" {
  bucket = module.multi_account_access["petpics3"].bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.dev.account_id}:root"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : [
          "${module.multi_account_access["petpics3"].bucket.arn}",
          "${module.multi_account_access["petpics3"].bucket.arn}/*"
        ],
      },
      {
        "Principal" : {
          "AWS" : "${aws_iam_role.mock_user_role.arn}"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:ListBucket",
          "s3:GetObjectTagging",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "${module.multi_account_access["petpics3"].bucket.arn}",
          "${module.multi_account_access["petpics3"].bucket.arn}/*"
        ]
      },
      {
        "Effect" : "Deny",
        "Principal" : {
          "AWS" : "${aws_iam_role.mock_user_role.arn}"
        },
        "Action" : [
          "s3:DeleteObject"
        ],
        "Resource" : [
          "${module.multi_account_access["petpics3"].bucket.arn}",
          "${module.multi_account_access["petpics3"].bucket.arn}/*"
        ]
      }
    ]
  })
}


resource "aws_s3_object" "object" {
  provider = aws.management

  count  = length(local.buckets_to_upload)
  bucket = module.multi_account_access[local.buckets_to_upload[count.index]].bucket.id
  key    = local.buckets_objects[local.buckets_to_upload[count.index]].obj
  source = "${path.module}/files/${local.buckets_to_upload[count.index]}/${local.buckets_objects[local.buckets_to_upload[count.index]].obj}"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  etag = filemd5("${path.module}/files/${local.buckets_to_upload[count.index]}/${local.buckets_objects[local.buckets_to_upload[count.index]].obj}")

  depends_on = [aws_s3_bucket_policy.petpics1, aws_s3_bucket_policy.petpics2, aws_s3_bucket_policy.petpics3]

  tags = {
    "Created by account_id" : "${data.aws_caller_identity.management.account_id}",
    "Created by canonical_id" : "${data.aws_canonical_user_id.management.id}"
  }
}
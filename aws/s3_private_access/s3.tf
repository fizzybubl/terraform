data "aws_caller_identity" "current" {

}


module "private" {
  source                  = "../s3/modules/bucket"
  bucket_prefix           = "privatecats"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Disabled"
}

resource "aws_s3_bucket_policy" "private" {
  bucket = module.private.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "OnlyThroughVpcEndpointGateway",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:*"],
        "Resource" : ["${module.private.bucket.arn}/*", "${module.private.bucket.arn}"],
        "Condition" : {
          "StringEquals" : {
            "aws:sourceVpce" : "${aws_vpc_endpoint.private_s3.id}"
          }
        }
      },
      {
        "Sid" : "AllowAdmin",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : ["s3:*"],
        "Resource" : ["${module.private.bucket.arn}/*", "${module.private.bucket.arn}"],
      }
    ]
  })
}


module "public" {
  source                  = "../s3/modules/bucket"
  bucket_prefix           = "publiccats"
  block_public_acls       = true
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = true
  versioning              = "Disabled"
}

resource "aws_s3_bucket_policy" "public" {
  bucket = module.public.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicRead",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : ["${module.public.bucket.arn}/*"]
      },
      {
        "Sid" : "PublicRead",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:ListBucket"],
        "Resource" : [module.public.bucket.arn]
      },
      {
        "Sid" : "AllowAdmin",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : ["s3:*"],
        "Resource" : ["${module.public.bucket.arn}/*", "${module.public.bucket.arn}"],
      }
    ]
  })
}



module "public_no_vpce" {
  source                  = "../s3/modules/bucket"
  bucket_prefix           = "publicdog"
  block_public_acls       = true
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = true
  versioning              = "Disabled"
}

resource "aws_s3_bucket_policy" "public_no_vpce" {
  bucket = module.public_no_vpce.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicRead",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:Get*", "s3:List*"],
        "Resource" : ["${module.public_no_vpce.bucket.arn}/*", "${module.public_no_vpce.bucket.arn}"]
      },
      {
        "Sid" : "AllowAdmin",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : ["s3:*"],
        "Resource" : ["${module.public_no_vpce.bucket.arn}/*", "${module.public_no_vpce.bucket.arn}"],
      }
    ]
  })
}



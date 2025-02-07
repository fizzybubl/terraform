module "cloudfront" {
  source                  = "../s3/modules/bucket"
  bucket_prefix           = "cloudfront-distribution-test-"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Disabled"
  force_destroy           = true
}


resource "aws_s3_bucket_cors_configuration" "cloudfront" {
  bucket = module.cloudfront.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
  }
}


resource "aws_s3_object" "js" {
  bucket = module.cloudfront.bucket.id
  key    = "scripts.js"
  source = "${path.module}/files/app/scripts.js"
  content_type = "text/javascript"
}

resource "aws_s3_object" "html" {
  bucket = module.cloudfront.bucket.id
  key    = "index.html"
  source = "${path.module}/files/app/index.html"
  content_type = "text/html"
}


resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = module.cloudfront.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudfrontServicePrincipalS3ReadOnly"
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Effect" : "Allow",
        "Action" : [
          "s3:Listbucket",
          "s3:GetObject"
        ],
        "Resource" : [
          "${module.cloudfront.bucket.arn}",
          "${module.cloudfront.bucket.arn}/*"
        ],
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : "${aws_cloudfront_distribution.s3.arn}"
          }
        }
      }
    ]
  })
}


# resource "aws_s3_bucket_website_configuration" "cloudfront" {
#   bucket = module.cloudfront.bucket.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }
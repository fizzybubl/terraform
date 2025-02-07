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
  bucket       = module.cloudfront.bucket.id
  key          = "scripts.js"
  content_type = "text/javascript"
  content = templatefile("${path.module}/files/app/scripts.tpl.js", {
    PRIVATE_PATCHES_BUCKET   = module.privatepatches.bucket.id,
    COGNITO_IDENTITY_POOL_ID = aws_cognito_identity_pool.cloudfront.id
  })
}

resource "aws_s3_object" "html" {
  bucket       = module.cloudfront.bucket.id
  key          = "index.html"
  content_type = "text/html"
  content = templatefile("${path.module}/files/app/index.tpl.html", {
    CLIENT_ID = var.google_client_id
  })
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

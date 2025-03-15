module "failover" {
  source                  = "../s3/modules/bucket"
  bucket                  = "www.mtlsexample.online"
  block_public_acls       = true
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = true
  versioning              = "Disabled"
}

resource "aws_s3_bucket_policy" "failover" {
  bucket = module.failover.bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicRead",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:GetObject"],
        "Resource" : ["${module.failover.bucket.arn}/*"]
      }
    ]
  })
}


resource "aws_s3_object" "html" {
  bucket       = module.failover.bucket.id
  key          = "index.html"
  content_type = "text/html"
  source       = "${path.module}/files/s3_failover/index.html"
}


resource "aws_s3_object" "pic" {
  bucket = module.failover.bucket.id
  key    = "minimal.jpg"
  source = "${path.module}/files/s3_failover/minimal.jpg"
}


resource "aws_s3_bucket_website_configuration" "failover" {
  bucket = module.failover.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}
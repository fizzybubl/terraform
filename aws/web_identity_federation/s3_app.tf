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
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
  }
}


resource "aws_s3_object" "js" {
  bucket = module.cloudfront.bucket.id
  key = "scripts.js"
  source = "${path.module}/files/app/scripts.js"
}

resource "aws_s3_object" "html" {
  bucket = module.cloudfront.bucket.id
  key = "index.html"
  source = "${path.module}/files/app/index.html"
}
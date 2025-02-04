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

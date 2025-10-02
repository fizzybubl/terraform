module "s3" {
  source                  = "../s3/modules/bucket"
  bucket                  = "s3-test-bucket-random"
  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
  versioning              = "Disabled"
}
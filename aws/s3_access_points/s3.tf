module "dev" {
  source                  = "../s3/modules/bucket"
  bucket                  = "destination-dev-test-sdd"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Enabled"
}
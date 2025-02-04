module "multi_account_access" {
  source                  = "../s3/modules/bucket"
  bucket_prefix           = ""
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
  versioning              = "Disabled"
  force_destroy           = true
}
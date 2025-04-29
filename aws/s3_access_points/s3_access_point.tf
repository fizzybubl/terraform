resource "aws_s3_access_point" "dev" {
  bucket = module.dev.bucket.id
  name   = "dev-access"
}
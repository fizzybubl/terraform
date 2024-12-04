resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id
  policy = jsonencode(var.bucket_policy)
}
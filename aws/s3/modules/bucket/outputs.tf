output "bucket" {
  value = aws_s3_bucket.this
}


output "versioning" {
  value = aws_s3_bucket_versioning.this
}
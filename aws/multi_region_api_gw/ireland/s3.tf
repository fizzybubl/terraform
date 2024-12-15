data "aws_caller_identity" "current_user" {

}

// TODO: Add S3 bucket + S3 object upload, to be used in lambda function as source code



resource "aws_s3_bucket" "replication" {
  bucket = "lambda-s3-replication-bucket"
  force_destroy = true
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.replication.id
  versioning_configuration {
    status = "Enabled"
  }
}

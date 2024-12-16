resource "aws_s3_bucket_lifecycle_configuration" "source" {
  bucket = aws_s3_bucket.source.id

  rule {
    id = "move-old-versions-to-IA"

    filter {
      prefix = "lambda-code/"
    }

    noncurrent_version_transition {
      newer_noncurrent_versions = 2
      noncurrent_days           = 30
      storage_class             = "STANDARD_IA"
    }

    status = "Enabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "destination" {
  provider = aws.second_region
  bucket = aws_s3_bucket.destination.id

  rule {
    id = "move-old-versions-to-IA"

    filter {
      prefix = "lambda-code/"
    }

    noncurrent_version_transition {
      newer_noncurrent_versions = 2
      noncurrent_days           = 30
      storage_class             = "STANDARD_IA"
    }

    status = "Enabled"
  }
}
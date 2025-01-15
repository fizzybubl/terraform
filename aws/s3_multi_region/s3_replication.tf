resource "aws_s3_bucket_replication_configuration" "frankfurt_to_dublin" {
  role   = aws_iam_role.allow_frankfurt_to_replicate_to_dublin.arn
  bucket = module.frankfurt.bucket.id

  rule {
    id = "replicate-all"

    filter {}

    status = "Enabled"

    destination {
      bucket        = module.dublin.bucket.arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }

  depends_on = [module.dublin, module.frankfurt]
}


resource "aws_s3_bucket_replication_configuration" "dublin_to_frankfurt" {
  provider = aws.west
  role     = aws_iam_role.allow_dublin_to_replicate_to_frankfurt.arn
  bucket   = module.dublin.bucket.id

  rule {
    id = "foobar"

    filter {}

    status = "Enabled"

    destination {
      bucket        = module.frankfurt.bucket.arn
      storage_class = "STANDARD"
    }
    delete_marker_replication {
      status = "Enabled"
    }
  }

  depends_on = [module.dublin, module.frankfurt]
}


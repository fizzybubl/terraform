resource "aws_s3_access_point" "dev" {
  bucket = module.dev.bucket.id
  name   = "dev-access"

  public_access_block_configuration {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  lifecycle {
    ignore_changes = [policy]
  }
}


resource "aws_s3_access_point" "e2e" {
  bucket = module.dev.bucket.id
  name   = "e2e-access"

  public_access_block_configuration {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  lifecycle {
    ignore_changes = [policy]
  }
}


resource "aws_s3control_access_point_policy" "dev" {
  access_point_arn = aws_s3_access_point.dev.arn

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "s3:*"
      Principal = {
        AWS = data.aws_iam_role.admin_dev.arn
      }
      Resource = ["${aws_s3_access_point.dev.arn}/object/*", "${aws_s3_access_point.dev.arn}"]
    },
    {
      Effect = "Allow"
      Action = "s3:List*"
      Principal = {
        AWS = aws_iam_role.dev.arn
      }
      Resource = ["${aws_s3_access_point.dev.arn}/object/dev/*", "${aws_s3_access_point.dev.arn}"]
    }]
  })
}


resource "aws_s3control_access_point_policy" "e2e" {
  access_point_arn = aws_s3_access_point.e2e.arn

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "s3:*"
      Principal = {
        AWS = data.aws_iam_role.admin_dev.arn
      }
      Resource = ["${aws_s3_access_point.e2e.arn}/object/*", "${aws_s3_access_point.e2e.arn}"]
    },
    {
      Effect = "Allow"
      Action = "s3:List*"
      Principal = {
        AWS = aws_iam_role.e2e.arn
      }
      Resource = ["${aws_s3_access_point.e2e.arn}/object/e2e/*", "${aws_s3_access_point.e2e.arn}"]
    }]
  })
}
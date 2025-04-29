data "aws_iam_role" "admin_dev" {
  name     = "Administrator"
}


resource "aws_iam_role" "dev" {
  name = "dev"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_role.admin_dev.arn
        }
      },
    ]
  })
}


resource "aws_iam_policy" "dev" {
  name        = "allow_access_to_dev"
  description = "My test policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Effect   = "Allow"
        Resource = ["${aws_s3_access_point.dev.arn}/object/*", aws_s3_access_point.dev.arn]
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "dev" {
  role       = aws_iam_role.dev.name
  policy_arn = aws_iam_policy.dev.arn
}


resource "aws_iam_role" "e2e" {
  name = "e2e"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_role.admin_dev.arn
        }
      },
    ]
  })
}


resource "aws_iam_policy" "e2e" {
  name        = "allow_access_to_e2e"
  description = "My test policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Effect   = "Allow"
        Resource = ["${aws_s3_access_point.e2e.arn}/object/*", aws_s3_access_point.e2e.arn]
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "e2e" {
  role       = aws_iam_role.e2e.name
  policy_arn = aws_iam_policy.e2e.arn
}
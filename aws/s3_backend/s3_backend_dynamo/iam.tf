data "aws_caller_identity" "management" {
}


resource "aws_iam_role" "minimum_s3" {
  name_prefix = "minimum_s3"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.management.account_id}:root"
        },
        "Effect" : "Allow"
      }
    ]
  })
}


resource "aws_iam_role_policy" "minimum_s3" {
  role = aws_iam_role.minimum_s3.name
  policy = file("${path.module}/files/minimum_access_for_s3_backend.json")
}

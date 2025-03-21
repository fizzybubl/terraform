resource "aws_iam_role" "s3_access" {
  name_prefix = "s3_access_for_ec2"
  path        = "/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "s3_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = aws_iam_role.s3_access.name
}


resource "aws_iam_instance_profile" "s3_access" {
  name_prefix = "ec2_test"
  role        = aws_iam_role.s3_access.name
  path        = "/"
}
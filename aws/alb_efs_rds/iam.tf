resource "aws_iam_role" "name" {
  name = "access-to-ssm"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  })
  tags = {
    "Name" : "Access To SSM"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.name.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "efs" {
  role       = aws_iam_role.name.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
}
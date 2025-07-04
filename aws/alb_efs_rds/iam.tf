resource "aws_iam_role" "ec2" {
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
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "efs" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
}


resource "aws_iam_instance_profile" "ec2" {
  name_prefix = "ec2_test"
  role        = aws_iam_role.ec2.name
  path        = "/"
}
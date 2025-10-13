data "aws_caller_identity" "current" {}

resource "aws_iam_role" "readonly_1" {
  name = "TestReadOnly_1"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}


resource "aws_iam_role" "readonly_2" {
  name = "TestReadOnly_2"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "readonly_1" {
  role       = aws_iam_role.readonly_1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "readonly_2" {
  role       = aws_iam_role.readonly_2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

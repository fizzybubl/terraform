data "aws_iam_role" "admin_dev" {
  name     = "Administrator"
}


resource "aws_iam_role" "dev" {
  name = "dev"
}
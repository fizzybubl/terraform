output "dev_role" {
    value = aws_iam_role.dev.arn
}


output "e2e_role" {
    value = aws_iam_role.e2e.arn
}
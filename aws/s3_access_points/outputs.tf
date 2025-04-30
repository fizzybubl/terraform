output "dev_role" {
    value = aws_iam_role.dev.arn
}


output "e2e_role" {
    value = aws_iam_role.e2e.arn
}


output "dev_ap" {
  value = aws_s3_access_point.dev.arn
}


output "e2e_ap" {
  value = aws_s3_access_point.e2e.arn
}
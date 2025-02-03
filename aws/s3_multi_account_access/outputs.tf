output "dev" {
  value = data.aws_caller_identity.dev
}

output "management" {
  value = data.aws_caller_identity.management
}


output "s3_role" {
  value = aws_iam_role.s3_access.arn
}


output "canonical_dev" {
  value = data.aws_canonical_user_id.dev
}

output "canonical_management" {
  value = data.aws_canonical_user_id.management
}
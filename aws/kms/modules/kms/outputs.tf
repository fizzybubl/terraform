output "key" {
  value = var.replica ? aws_kms_replica_key.this[0] : aws_kms_key.this[0]
}

output "alias" {
  value = aws_kms_alias.this
}
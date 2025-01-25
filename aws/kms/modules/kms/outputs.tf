output "key" {
  value = var.replica ? aws_kms_replica_key.this[0] : aws_kms_key.this[0]
}
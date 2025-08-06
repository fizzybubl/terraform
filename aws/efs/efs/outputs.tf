output "mount_target_dns" {
  value = { for key, subnet in var.subnet_ids : key => aws_efs_mount_target.this[key].mount_target_dns_name }
}


output "efs_dns" {
  value = aws_efs_file_system.this.dns_name
}

output "efs_id" {
  value = aws_efs_file_system.this.id
}


output "access_point_arn" {
  value = var.access_point != null ? aws_efs_access_point.this[0].arn : null
}

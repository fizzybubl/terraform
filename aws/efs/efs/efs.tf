resource "aws_efs_file_system" "this" {
  creation_token                  = var.name
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps

  protection {
    replication_overwrite = var.replication_overwrite
  }
  tags = var.tags
}


resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id
  backup_policy {
    status = var.backup_status
  }
}



resource "aws_efs_mount_target" "this" {
  for_each        = var.subnet_ids
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value.subnet_id
  security_groups = each.value.security_groups
}


resource "aws_efs_access_point" "this" {
  count = var.access_point != null ? 1 : 0
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    gid = var.access_point.gid
    uid = var.access_point.uid
  }

  root_directory {
    path = var.access_point.path
    creation_info {
      owner_gid   = var.access_point.owner_gid
      owner_uid   = var.access_point.owner_uid
      permissions = var.access_point.permissions
    }
  }

  tags = var.access_point.tags
}
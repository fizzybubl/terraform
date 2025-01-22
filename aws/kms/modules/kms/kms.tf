resource "aws_kms_key" "this" {
  description              = var.description
  multi_region             = var.multi_region
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  enable_key_rotation      = var.enable_key_rotation
  rotation_period_in_days  = var.rotation_period_in_days
  deletion_window_in_days  = var.deletion_window_in_days
}


resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.this.key_id
}


resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = var.key_policy
}
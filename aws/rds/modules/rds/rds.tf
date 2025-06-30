resource "aws_db_subnet_group" "this" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance_role_association" "this" {
  db_instance_identifier = aws_db_instance.this.identifier
  feature_name           = "S3_INTEGRATION"
  role_arn               = var.instance_role_arn

  # Only necessary where the instance identifier is a known string value; ensuring recreation when the instance is replaced. Requires Terraform 1.2 or later.
  lifecycle {
    replace_triggered_by = [
      aws_db_instance.this.id
    ]
  }
}


resource "aws_db_instance" "this" {
  db_name                = var.db_name
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = var.skip_final_snapshot
}
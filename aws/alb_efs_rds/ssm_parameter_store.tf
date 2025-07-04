resource "aws_ssm_parameter" "db_user" {
  name        = var.db_user.ssm_name
  description = "Wordpress Database User"
  type        = "String"
  tier        = "Standard"
  data_type   = "text"
  value       = var.db_user.value

  tags = {
    environment = "dev"
  }
}


resource "aws_ssm_parameter" "db_name" {
  name        = var.db_name.ssm_name
  description = "Wordpress Database Name"
  type        = "String"
  tier        = "Standard"
  data_type   = "text"
  value       = var.db_name.value

  tags = {
    environment = "dev"
  }
}


resource "aws_ssm_parameter" "db_endpoint" {
  name        = var.db_endpoint.ssm_name
  description = "Wordpress Database Endpoint"
  type        = "String"
  tier        = "Standard"
  data_type   = "text"
  value       = module.rds.db_endpoint

  tags = {
    environment = "dev"
  }
}


resource "aws_ssm_parameter" "db_pw" {
  name        = var.db_pw.ssm_name
  description = "Wordpress Database Password"
  type        = "SecureString"
  tier        = "Standard"
  data_type   = "text"
  value       = var.db_pw.value
  key_id      = "alias/aws/ssm"

  tags = {
    environment = "dev"
  }
}

resource "aws_ssm_parameter" "db_root_pw" {
  name        = var.db_root_pw.ssm_name
  description = "Wordpress Database Root Password"
  type        = "SecureString"
  tier        = "Standard"
  data_type   = "text"
  value       = var.db_pw.value
  key_id      = "alias/aws/ssm"

  tags = {
    environment = "dev"
  }
}
resource "aws_ssm_parameter" "db_user" {
  name        = var.db_user
  description = "Wordpress Database User"
  type        = "String"
  tier        = "Standard"
  data_type   = "text"
  value       = "a4lwordpressuser"

  tags = {
    environment = "dev"
  }
}


resource "aws_ssm_parameter" "db_name" {
  name        = var.db_name
  description = "Wordpress Database Name"
  type        = "String"
  tier        = "Standard"
  data_type   = "text"
  value       = "a4lwordpressdb"

  tags = {
    environment = "dev"
  }
}


resource "aws_ssm_parameter" "db_endpoint" {
  name        = var.db_endpoint
  description = "Wordpress Database Endpoint"
  type        = "String"
  tier        = "Standard"
  data_type   = "text"
  value       = "localhost"

  tags = {
    environment = "dev"
  }
}


resource "aws_ssm_parameter" "db_pw" {
  name        = var.db_pw
  description = "Wordpress Database Password"
  type        = "SecureString"
  tier        = "Standard"
  data_type   = "text"
  value       = var.db_pw_value
  key_id      = "alias/aws/ssm"

  tags = {
    environment = "dev"
  }
}

resource "aws_ssm_parameter" "db_root_pw" {
  name        = var.db_root_pw
  description = "Wordpress Database Root Password"
  type        = "SecureString"
  tier        = "Standard"
  data_type   = "text"
  value       = var.db_root_pw_value
  key_id      = "alias/aws/ssm"

  tags = {
    environment = "dev"
  }
}
locals {
  lambda_name = var.function_name != null ? aws_lambda_function.this[0].function_name : var.lambda_name

  # OUTPUTS
  alias_arn  = var.alias_name != null ? aws_lambda_alias.this[0].arn : null
  invoke_arn = var.alias_name != null ? aws_lambda_alias.this[0].invoke_arn : aws_lambda_function.this[0].arn
}


resource "aws_lambda_alias" "this" {
  count            = var.alias_name != null ? 1 : 0
  name             = var.alias_name
  function_name    = local.lambda_name
  function_version = var.lambda_version

  dynamic "routing_config" {
    for_each = var.version_weights != null ? [var.version_weights] : []

    content {
      additional_version_weights = var.version_weights
    }
  }
}


resource "aws_lambda_function" "this" {
  count             = var.function_name != null ? 1 : 0
  function_name     = var.function_name
  role              = var.execution_role_arn
  architectures     = var.architectures
  package_type      = var.package_type
  handler           = var.handler
  filename          = var.filename
  image_uri         = var.image_uri
  memory_size       = var.memory_size
  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  s3_object_version = var.s3_object_version
  source_code_hash  = null
  runtime           = var.runtime

  dead_letter_config {
    target_arn = var.dlq_arn
  }

  environment {
    variables = var.env_variables
  }

  ephemeral_storage {
    size = var.tmp_size
  }

  file_system_config {
    local_mount_path = var.local_mount_path
    arn              = var.efs_arn
  }

  image_config {
    command           = var.image_config.command
    entry_point       = var.image_config.entry_point
    working_directory = var.image_config.working_directory
  }

  logging_config {
    application_log_level = var.logging_config.application_log_level
    log_format            = var.logging_config.log_format
    log_group             = var.logging_config.log_group
    system_log_level      = var.logging_config.system_log_level
  }

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }
}
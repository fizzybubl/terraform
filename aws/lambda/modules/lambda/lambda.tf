locals {
  lambda_name = var.new_func ? aws_lambda_function.this[0].function_name : var.function_name

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
  count             = var.new_func ? 1 : 0
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
  timeout           = var.timeout

  dynamic "dead_letter_config" {
    for_each = var.dlq_arn != null ? [var.dlq_arn] : []
    content {
      target_arn = each.value
    }
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

  dynamic "image_config" {
    for_each = var.image_config != null ? [var.image_config] : []

    content {
      command           = each.value.command
      entry_point       = each.value.entry_point
      working_directory = each.value.working_directory
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []

    content {
      application_log_level = each.value.application_log_level
      log_format            = each.value.log_format
      log_group             = each.value.log_group
      system_log_level      = each.value.system_log_level
    }
  }

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }
}
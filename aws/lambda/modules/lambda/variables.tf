variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = null
}

variable "execution_role_arn" {
  description = "The ARN of the IAM role that Lambda assumes"
  type        = string
  default     = null
}

variable "architectures" {
  description = "Instruction set architecture for your Lambda function"
  type        = list(string)
  default     = ["x86_64"]
}

variable "package_type" {
  description = "The type of deployment package (Zip or Image)"
  type        = string
  default     = "zip"
}

variable "handler" {
  description = "Function entrypoint in your code"
  type        = string
  default     = "index.handler"
}

variable "filename" {
  description = "Path to the deployment package on local disk"
  type        = string
  default     = null
}

variable "image_uri" {
  description = "URI of a container image in ECR"
  type        = string
  default     = null
}

variable "memory_size" {
  description = "Amount of memory in MB your function can use"
  type        = number
  default     = 128
}

variable "s3_bucket" {
  description = "S3 bucket containing the function code"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of the function code"
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "Object version containing the function code"
  type        = string
  default     = null
}

variable "runtime" {
  description = "Runtime environment for the Lambda function"
  type        = string
  default     = null
}

variable "dlq_arn" {
  description = "ARN of the dead letter queue"
  type        = string
  default     = null
}

variable "env_variables" {
  description = "Map of environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tmp_size" {
  description = "Size of the ephemeral storage in MB"
  type        = number
  default     = 512
}

variable "local_mount_path" {
  description = "The path where the EFS volume will be mounted"
  type        = string
  default     = null
}

variable "efs_arn" {
  description = "ARN of the EFS access point"
  type        = string
  default     = null
}

variable "image_config" {
  description = "Image configuration for Lambda container"
  type = object({
    command           = list(string)
    entry_point       = list(string)
    working_directory = string
  })
  default = null
}

variable "logging_config" {
  description = "Logging configuration for the Lambda function"
  type = object({
    application_log_level = string
    log_format            = string
    log_group             = string
    system_log_level      = string
  })
  default = null
}

variable "security_group_ids" {
  description = "List of security group IDs for the Lambda function"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Lambda function"
  type        = list(string)
  default     = []
}


### ALIAS ###
variable "alias_name" {
  description = "Name of the Lambda alias"
  type        = string
}

variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_version" {
  description = "Lambda function version to which the alias points"
  type        = string
}

variable "version_weights" {
  description = "Map of additional Lambda versions and their weights"
  type        = map(number)
  default     = null
}

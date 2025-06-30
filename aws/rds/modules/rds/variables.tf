variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The version of the RDS engine"
  type        = string
  default     = "8.0.36"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "The maximum allocated storage in gigabytes"
  type        = number
  default     = 50
}

variable "username" {
  description = "The master username for the database"
  type        = string
}

variable "password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when destroying the instance"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "Subnet IDs where to deploy RDS"
  type        = list(string)
}


variable "instance_role_arn" {
  type        = string
  description = "Instace role arn"
}


variable "engine_lifecycle_support" {
  type        = string
  description = "The life cycle type for this DB instance. This setting applies only to RDS for MySQL and RDS for PostgreSQL."
  default     = "open-source-rds-extended-support"
}

variable "identifier" {
  type        = string
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  default     = null
}

variable "storage_type" {
  type    = string
  default = "gp3"
}

variable "iops" {
  type    = number
  default = 100
}
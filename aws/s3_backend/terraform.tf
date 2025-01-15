terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "bucket-name: must be created manually"
    dynamodb_table = "dynamo table: must be created manually"
    region = "region"
    profile = "profile"
    key = "s3/object/key"
  }
}
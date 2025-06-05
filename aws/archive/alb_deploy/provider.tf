terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {

  }
}

# Configure the AWS Provider
provider "aws" {
  profile                  = var.profile
  shared_credentials_files = ["C:\\Users\\drago\\.aws\\credentials"]
  region                   = var.region
}

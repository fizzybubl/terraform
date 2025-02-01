# Configure the AWS Provider
provider "aws" {
  alias   = "dev"
  profile = "admin-dev"
  region  = var.region
}


provider "aws" {
  profile = "admin"
  region  = var.region
}


provider "aws" {
  alias   = "prod"
  profile = "admin-prod"
  region  = var.region
}
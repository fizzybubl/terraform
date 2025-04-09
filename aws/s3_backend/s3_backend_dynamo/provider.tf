# Configure the AWS Provider
provider "aws" {
  profile                  = var.profile
  shared_credentials_files = ["C:\\Users\\danii\\.aws\\credentials"]
  region                   = var.region
}
# Configure the AWS Provider
provider "aws" {
  profile                  = var.profile
  shared_credentials_files = ["C:\\Users\\danii\\.aws\\credentials"]
  region                   = var.region
}


provider "aws" {
  alias                    = "second_region"
  profile                  = var.profile
  shared_credentials_files = ["C:\\Users\\danii\\.aws\\credentials"]
  region                   = var.second_region
}

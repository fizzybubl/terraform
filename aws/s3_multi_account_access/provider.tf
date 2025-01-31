# Configure the AWS Provider
provider "aws" {
  profile = var.profile
  region  = var.region
}


provider "aws" {
  alias   = "management"
  profile = "admin"
  region  = var.region
}
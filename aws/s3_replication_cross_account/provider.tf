provider "aws" {
  alias   = "dev"
  profile = var.dev_profile
  region  = var.region
}


provider "aws" {
  alias   = "prod"
  profile = var.prod_profile
  region  = var.region
}

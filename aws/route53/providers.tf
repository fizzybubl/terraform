provider "aws" {
  profile = "admin"
  region  = "eu-central-1"
}


provider "aws" {
  alias   = "ire"
  profile = "admin"
  region  = "eu-west-1"
}
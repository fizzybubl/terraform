provider "aws" {
  profile = var.profile
  region  = "eu-central-1"
}


provider "aws" {
  profile = var.profile
  region  = "eu-central-1"
  alias   = "fra"
}


provider "aws" {
  alias   = "dub"
  profile = var.profile
  region  = "eu-west-1"
}
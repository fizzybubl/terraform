terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    # kubectl = {
    #   source = "gavinbunney/kubectl"
    #   version = ">= 1.14"
    # }
  }

  backend "local" {

  }
}
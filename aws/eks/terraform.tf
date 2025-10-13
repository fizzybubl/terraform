terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.1"
    }
  }

  backend "local" {

  }
}
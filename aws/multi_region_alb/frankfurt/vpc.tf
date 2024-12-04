module "vpc" {
  source = "../../vpc/modules/vpc"

  providers = {
    aws = aws
  }
}
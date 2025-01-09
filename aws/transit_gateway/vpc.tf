module "vpc1" {
  source = "../vpc/modules/vpc"
  vpc_data = {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
  }
}


module "vpc2" {
  source = "../vpc/modules/vpc"
  vpc_data = {
    cidr_block = "10.1.0.0/16"
    instance_tenancy = "default"
  }
}


module "vpc3" {
  source = "../vpc/modules/vpc"
  vpc_data = {
    cidr_block = "10.2.0.0/16"
    instance_tenancy = "default"
  }
}
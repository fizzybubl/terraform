module "private_vpc" {
  source = "../vpc/modules/vpc_v3"
  igw    = false
  vpc_tags = {
    Name = "Private VPC"
  }
}


module "subnet_1" {
  source     = "../vpc/modules/subnet"
  vpc_id     = module.private_vpc.vpc_id
  cidr_block = "10.0.1.0/24"
  az_id      = "euc1-az1"
}


module "subnet_2" {
  source         = "../vpc/modules/subnet"
  vpc_id         = module.private_vpc.vpc_id
  cidr_block     = "10.0.2.0/24"
  az_id          = "euc1-az2"
  create_rtb = false
  route_table_id = module.subnet_1.route_table_id
}

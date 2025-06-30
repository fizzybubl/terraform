module "rds" {
  source                 = "./modules/rds"
  username               = "admin"
  password               = "admin"
  subnet_ids             = ""
  db_name                = "test"
  vpc_security_group_ids = [""]
  instance_role_arn      = ""
}
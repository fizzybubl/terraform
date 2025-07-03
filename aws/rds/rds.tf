module "rds" {
  source                 = "./modules/rds"
  username               = "admin"
  password               = "admin"
  subnet_ids             = [for az in local.az_ids: module.cloud_db[az]]
  db_name                = "test"
  vpc_security_group_ids = [""]
  instance_role_arn      = ""
}